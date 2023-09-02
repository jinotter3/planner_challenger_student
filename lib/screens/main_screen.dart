import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planner_challenger_student/components/task-add-card.dart';
import 'package:planner_challenger_student/models/daily_task_list.dart';

import '../auth.dart';
import '../components/date-card.dart';
import '../components/student-card.dart';
import '../models/student.dart';

// Using a FutureProvider for asynchronous operations
final studentDataProvider = FutureProvider<Student?>((ref) async {
  final user = FirebaseAuth
      .instance.currentUser; // assuming you want the current logged in user
  if (user == null) return null; // Handle the case when the user is null

  final dbref = FirebaseDatabase.instance.ref("students");
  final event = await dbref.child(user.uid).once();

  final map = event.snapshot.value as Map<dynamic, dynamic>;
  return Student(
    name: map['info']['name'],
    studentId: map['info']['studentId'],
    id: map['info']['id'],
  );
});

final dailyTaskListProvider = StreamProvider<DailyTaskList>((ref) {
  final user = FirebaseAuth
      .instance.currentUser; // assuming you want the current logged in user
  if (user == null)
    return Stream.empty(); // Handle the case when the user is null

  final dbref = FirebaseDatabase.instance.ref("students");
  final event = dbref.child(user.uid).child("days").onValue;
  return event.map((event) {
    final map = event.snapshot.value as Map<dynamic, dynamic>;
    return DailyTaskList.fromJson(map);
  });
});

final class MainScreen extends ConsumerWidget {
  MainScreen({
    required this.user,
    required this.dateShown,
    required this.today,
    Key? key,
  }) : super(key: key);

  final User user;
  static String get routeName => 'main';
  static String get routeLocation => '/$routeName';
  final DateTime dateShown;
  final DateTime today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsyncValue = ref.watch(studentDataProvider);
    final taskListProvider = ref.watch(dailyTaskListProvider);
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
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  DateCard(
                    date: dateShown,
                  ),
                ],
              ),
              Container(
                  height: 600,
                  child: Column(
                    children: [
                      taskListProvider.when(
                        data: (dailyTaskList) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: dailyTaskList.tasks.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text("과목"),
                                  subtitle: Text(
                                    dailyTaskList.tasks[index].title,
                                  ),
                                  trailing: Text(
                                    dailyTaskList.tasks[index].numberOfQuestions
                                        .toString(),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        loading: () => CircularProgressIndicator(),
                        error: (error, stack) {
                          print(stack);
                          return Text("Error loading data");
                        },
                      ),
                    ],
                  )),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return TaskAddCard(
                        date: dateShown,
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
}
