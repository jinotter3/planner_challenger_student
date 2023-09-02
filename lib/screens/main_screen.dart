import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:planner_challenger_student/components/task-add-card.dart';
import 'package:planner_challenger_student/models/daily_task_list.dart';

import '../auth.dart';
import '../components/date-card.dart';
import '../components/student-card.dart';
import '../components/task_card.dart';
import '../models/student.dart';

// Using a FutureProvider for asynchronous operations
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
  print("map: $map");
  return DailyTaskList.fromJson(map as Map<String, dynamic>, currentDate);
});

final dateShownProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final class MainScreen extends ConsumerWidget {
  MainScreen({
    required this.user,
    // required this.dateShown,
    required this.today,
    Key? key,
  }) : super(key: key);

  final User user;
  static String get routeName => 'main';
  static String get routeLocation => '/$routeName';
  // DateTime dateShown;
  final DateTime today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsyncValue = ref.watch(studentDataProvider);
    final dateProvider = ref.watch(dateShownProvider);
    final taskListProvider = ref.watch(dailyTaskListProvider(dateProvider));

    return Scaffold(
      body: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              studentAsyncValue.when(
                data: (student) => StudentCard(
                  student: student as Student,
                ),
                loading: () => CircularProgressIndicator(),
                error: (error, stack) => Text("Error loading data"),
              ),
              // DatePicker
              ElevatedButton(
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: dateProvider,
                    firstDate: DateTime.now().subtract(Duration(days: 365)),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  ).then((value) {
                    if (value != null) {
                      ref.read(dateShownProvider.notifier).update((date) {
                        return value;
                      });
                    }
                  });
                },
                child: const Text("날짜 선택"),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  DateCard(
                    date: dateProvider,
                  ),
                ],
              ),
              SingleChildScrollView(
                child: taskListProvider.when(
                  data: (dailyTaskList) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: dailyTaskList.getTasksBySubject().keys.map(
                        (e) {
                          return Column(
                            children: [
                              Text(
                                e,
                                style: TextStyle(fontSize: 24),
                              ),
                              ...dailyTaskList
                                  .getTasksBySubject()[e]!
                                  .map((e) => TaskCard(
                                        task: e,
                                        currentDate: dateProvider,
                                        deleteTask: () {
                                          deleteTask(e.id, dateProvider);
                                        },
                                        updateTask: (newTask) {
                                          updateTask(
                                              e.id, newTask, dateProvider);
                                        },
                                        uploadImage: (image) {
                                          uploadImage(
                                              e.id, image, dateProvider);
                                        },
                                      ))
                                  .toList(),
                            ],
                          );
                        },
                      ).toList(),
                    );
                  },
                  loading: () => CircularProgressIndicator(),
                  error: (error, stack) {
                    print(stack);
                    return Text("Error loading data");
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return TaskAddCard(
                        date: dateProvider,
                      );
                    },
                  );
                },
                child: const Text("새 Task 추가"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                child: const Text("Logout"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<String> deleteTask(String id, DateTime dateShown) async {
    final dbref = FirebaseDatabase.instance
        .ref("students/${FirebaseAuth.instance.currentUser!.uid}/days");
    final dbref2 = dbref.child(dateShown.toString().split(" ")[0]);
    final dbref3 = dbref2.child(id);
    await dbref3.remove();
    print("id: $id deleted");
    return "success";
  }

  Future<String> updateTask(
      String id, Map<String, dynamic> newTaskJson, DateTime dateShown) async {
    final dbref = FirebaseDatabase.instance
        .ref("students/${FirebaseAuth.instance.currentUser!.uid}/days");
    final dbref2 = dbref.child(dateShown.toString().split(" ")[0]);
    final dbref3 = dbref2.child(id);
    await dbref3.update({
      "subject": newTaskJson["subject"],
      "content": newTaskJson["content"],
      "numOfQuestions": newTaskJson["numOfQuestions"].toString(),
      "done": newTaskJson["done"],
    });
    return "success";
  }

  Future<String> uploadImage(
      String id, Uint8List imageData, DateTime dateShown) async {
    final storageRef = FirebaseStorage.instance.ref("students/${user.uid}");
    // set image name to task id
    String imageName = id;
    final storageRef2 = storageRef.child(imageName);
    final data = storageRef2.putData(imageData);
    data.snapshotEvents.listen((event) {
      print("Progress: ${event.bytesTransferred / event.totalBytes}");
    });
    data.whenComplete(() async {
      final url = await storageRef2.getDownloadURL();
      final dbref = FirebaseDatabase.instance.ref(
          "students/${user.uid}/days/${dateShown.toString().split(" ")[0]}/${id}");
      dbref.update({"imageUrl": url, "done": true});
    });
    return "success";
  }
}
