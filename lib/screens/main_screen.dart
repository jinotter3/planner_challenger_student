import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:planner_challenger_student/auth.dart';
import 'package:planner_challenger_student/auth_service.dart';
import 'package:planner_challenger_student/components/task-add-card.dart';
import 'package:planner_challenger_student/screens/info_screen.dart';
import 'package:planner_challenger_student/screens/login_screen.dart';
import 'package:table_calendar/table_calendar.dart';

import '../components/date-card.dart';
import '../components/student-card.dart';
import '../components/task_card.dart';
import '../models/student.dart';

import './main_providers.dart';

final class MainScreen extends ConsumerWidget {
  final AuthService _authService = AuthService();
  static String get routeName => 'main';
  static String get routeLocation => '/$routeName';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    return Scaffold(
      body: authState.when(
        data: (user) {
          if (user == null) {
            GoRouter.of(context).go(LoginScreen.routeLocation);
          } else {
            // GoRouter.of(context).go(MainScreen.routeLocation, extra: user);
            return _MainScreen(user: user, today: DateTime.now());
          }
        },
        loading: () => CircularProgressIndicator(),
        error: (_, __) => Text('Error occurred!'),
      ),
    );
  }
}

final class _MainScreen extends ConsumerWidget {
  _MainScreen({
    required this.user,
    // required this.dateShown,
    required this.today,
    Key? key,
  }) : super(key: key);

  final User user;
  // DateTime dateShown;
  final DateTime today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsyncValue = ref.watch(studentDataProvider);
    final dateTimeNotifier = ref.watch(dateTimeProvider);
    print(dateTimeNotifier.selectedDate);
    final taskListProvider =
        ref.watch(dailyTaskListProvider(dateTimeNotifier.selectedDate));
    if (MediaQuery.of(context).size.width > 600) {
      return Scaffold(
        appBar: AppBar(
          title: Text("30일 챌린지",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
                onPressed: () {
                  GoRouter.of(context)
                      .go(InfoScreen.routeLocation, extra: user);
                },
                icon: Icon(Icons.emoji_events),
                color: Colors.white),
            IconButton(
              icon: Icon(Icons.logout),
              color: Colors.white,
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
        body: Row(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: SingleChildScrollView(
                      child: taskListProvider.when(
                        data: (dailyTaskList) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                dailyTaskList.getTasksBySubject().keys.map(
                              (e) {
                                return Column(
                                  children: [
                                    Text(
                                      e,
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    ...dailyTaskList
                                        .getTasksBySubject()[e]!
                                        .map((e) {
                                      return TaskCard(
                                        task: e,
                                        currentDate:
                                            dateTimeNotifier.selectedDate,
                                        deleteTask: () {
                                          deleteTask(e.id,
                                              dateTimeNotifier.selectedDate);
                                          print(dateTimeNotifier.selectedDate);
                                          //refresh page with gorouters
                                          GoRouter.of(context).refresh();
                                          print("refreshed");
                                          print(dateTimeNotifier.selectedDate
                                              .toString());
                                        },
                                        updateTask: (newTask) {
                                          updateTask(e.id, newTask,
                                              dateTimeNotifier.selectedDate);
                                          GoRouter.of(context).refresh();
                                        },
                                        uploadImage: (image) {
                                          uploadImage(
                                              e.id,
                                              image,
                                              dateTimeNotifier.selectedDate,
                                              context);
                                          GoRouter.of(context).refresh();
                                        },
                                      );
                                    }).toList(),
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
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if ((dateTimeNotifier.selectedDate
                                      .difference(DateTime.now())
                                      .inHours /
                                  24)
                              .round() <
                          -1) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("에러"),
                            content: Text("목표를 추가할 수 없는 기간입니다."),
                          ),
                        );
                        return;
                      }
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return TaskAddCard(
                            date: dateTimeNotifier.selectedDate,
                          );
                        },
                      );
                    },
                    child: const Text("새 목표 추가",
                        style: TextStyle(fontSize: 15, color: Colors.black)),
                  ),
                ],
              ),
            ),
            VerticalDivider(
              color: Colors.grey,
              thickness: 1,
              width: 1,
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  DateCard(
                    date: dateTimeNotifier.selectedDate,
                  ),
                  studentAsyncValue.when(
                    data: (student) => StudentCard(
                      student: student as Student,
                    ),
                    loading: () => CircularProgressIndicator(),
                    error: (error, stack) => Text("Error loading data"),
                  ),
                  TableCalendar(
                    focusedDay: dateTimeNotifier.selectedDate,
                    firstDay: DateTime.now().subtract(Duration(days: 365)),
                    lastDay: DateTime.now().add(Duration(days: 365)),
                    calendarFormat: CalendarFormat.month,
                    // delete the button
                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                    ),
                    selectedDayPredicate: (day) {
                      return isSameDay(dateTimeNotifier.selectedDate, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      dateTimeNotifier.selectedDate = selectedDay;
                      print(dateTimeNotifier.selectedDate);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("30일 챌린지",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              color: Colors.white,
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: SingleChildScrollView(
                  child: taskListProvider.when(
                    data: (dailyTaskList) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: dailyTaskList.getTasksBySubject().keys.map(
                          (e) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  e,
                                  style: TextStyle(fontSize: 20),
                                ),
                                ...dailyTaskList
                                    .getTasksBySubject()[e]!
                                    .map((e) => TaskCard(
                                          task: e,
                                          currentDate:
                                              dateTimeNotifier.selectedDate,
                                          deleteTask: () {
                                            deleteTask(e.id,
                                                dateTimeNotifier.selectedDate);
                                            print(
                                                dateTimeNotifier.selectedDate);
                                            //refresh page with gorouters
                                            GoRouter.of(context).refresh();
                                            print("refreshed");
                                            print(dateTimeNotifier.selectedDate
                                                .toString());
                                          },
                                          updateTask: (newTask) {
                                            updateTask(e.id, newTask,
                                                dateTimeNotifier.selectedDate);
                                            GoRouter.of(context).refresh();
                                          },
                                          uploadImage: (image) {
                                            uploadImage(
                                                e.id,
                                                image,
                                                dateTimeNotifier.selectedDate,
                                                context);
                                            GoRouter.of(context).refresh();
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
              ),
              ElevatedButton(
                onPressed: () {
                  if ((dateTimeNotifier.selectedDate
                                  .difference(DateTime.now())
                                  .inHours /
                              24)
                          .round() <
                      -1) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text("에러"),
                        content: Text("목표를 추가할 수 없는 기간입니다."),
                      ),
                    );
                    return;
                  }
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return TaskAddCard(
                        date: dateTimeNotifier.selectedDate,
                      );
                    },
                  );
                },
                child: const Text("새 목표 추가",
                    style: TextStyle(fontSize: 13, color: Colors.black)),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              DateCard(
                date: dateTimeNotifier.selectedDate,
              ),
              studentAsyncValue.when(
                data: (student) => StudentCard(
                  student: student as Student,
                ),
                loading: () => CircularProgressIndicator(),
                error: (error, stack) => Text("Error loading data"),
              ),
              TableCalendar(
                focusedDay: dateTimeNotifier.selectedDate,
                firstDay: DateTime.now().subtract(Duration(days: 365)),
                lastDay: DateTime.now().add(Duration(days: 365)),
                calendarFormat: CalendarFormat.month,
                // delete the button
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                ),
                selectedDayPredicate: (day) {
                  return isSameDay(dateTimeNotifier.selectedDate, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  dateTimeNotifier.selectedDate = selectedDay;
                  print(dateTimeNotifier.selectedDate);
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<String> deleteTask(String id, DateTime dateShown) async {
    final dbref = FirebaseDatabase.instance
        .ref("students/${FirebaseAuth.instance.currentUser!.uid}/days");
    final dbref2 = dbref.child(dateShown.toString().split(" ")[0]);
    final dbref3 = dbref2.child(id);
    // read image url
    final DatabaseEvent event = await dbref3.once();
    final map = event.snapshot.value as Map<dynamic, dynamic>;
    final imageUrl = map["imageUrl"];
    if (imageUrl != "") {
      // delete image
      final storageRef =
          FirebaseStorage.instance.ref("students/${user.uid}/$id");
      await storageRef.delete();
    }
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

  Future<String> uploadImage(String id, Uint8List imageData, DateTime dateShown,
      BuildContext context) async {
    final storageRef = FirebaseStorage.instance.ref("students/${user.uid}");
    // set image name to task id
    String imageName = id;
    final storageRef2 = storageRef.child(imageName);
    final data = storageRef2.putData(imageData);
    showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))
          ),
          backgroundColor: Colors.black87,
          content: LoadingIndicator(
            text: "이미지 업로드 중...",
          ),
        )
      );
    },
  );
    data.snapshotEvents.listen((event) {
      print("Progress: ${event.bytesTransferred / event.totalBytes}");
    });
    data.whenComplete(() async {
      final url = await storageRef2.getDownloadURL();
      final dbref = FirebaseDatabase.instance.ref(
          "students/${user.uid}/days/${dateShown.toString().split(" ")[0]}/${id}");
      dbref.update({"imageUrl": url, "done": true});
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("업로드 완료!"),
          content: Text("목표를 달성했습니다"),
        ),
      );
    });
    return "success";
  }

  Widget LoadingIndicator({required String text}) {
    return Container(
        padding: EdgeInsets.all(16),
        color: Colors.black.withOpacity(0.8),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _getLoadingIndicator(),
              _getHeading(),
              _getText(text)
            ]));
  }

  Widget _getLoadingIndicator() {
    return Padding(
        child: Container(
            child: CircularProgressIndicator(strokeWidth: 3),
            width: 32,
            height: 32),
        padding: EdgeInsets.only(bottom: 16));
  }

  Widget _getHeading() {
    return Padding(
        child: Text(
          'Please wait …',
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        padding: EdgeInsets.only(bottom: 4));
  }

  Widget _getText(String displayedText) {
    return Text(
      displayedText,
      style: TextStyle(color: Colors.white, fontSize: 14),
      textAlign: TextAlign.center,
    );
  }
}
