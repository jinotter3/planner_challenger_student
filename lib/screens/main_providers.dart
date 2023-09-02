// Using a FutureProvider for asynchronous operations
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/daily_task_list.dart';
import '../models/student.dart';

final studentDataProvider = FutureProvider<Student?>((ref) async {
  final user = FirebaseAuth
      .instance.currentUser; // assuming you want the current logged in user
  if (user == null) return null; // Handle the case when the user is null

  final dbref = FirebaseDatabase.instance.ref("students/${user.uid}/info");
  final event = await dbref.once();

  final map = event.snapshot.value as Map<dynamic, dynamic>;
  return Student(
    name: map['name'],
    studentId: map['studentId'],
    id: map['id'],
  );
});

final dailyTaskListProvider =
    FutureProvider.family<DailyTaskList, DateTime>((ref, currentDate) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return DailyTaskList(tasks: [], date: currentDate);

  String dateString = currentDate.toString().split(" ")[0];
  final dbref =
      FirebaseDatabase.instance.ref("students/${user.uid}/days/$dateString");

  final DatabaseEvent event = await dbref.once();
  if (event.snapshot.value == null) {
    return DailyTaskList(tasks: [], date: currentDate);
  }
  final map = event.snapshot.value as Map<dynamic, dynamic>;
  return DailyTaskList.fromJson(map as Map<String, dynamic>, currentDate);
});

final dateTimeProvider =
    ChangeNotifierProvider<DateTimeNotifier>((ref) => DateTimeNotifier());

class DateTimeNotifier extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  set selectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }
}
