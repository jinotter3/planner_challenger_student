import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth.dart';
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

final class MainScreen extends ConsumerWidget {
  MainScreen({required this.user, Key? key}) : super(key: key);

  final User user;
  static String get routeName => 'main';
  static String get routeLocation => '/$routeName';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsyncValue = ref.watch(studentDataProvider);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            studentAsyncValue.when(
              data: (student) => Text("Welcome ${student?.name ?? 'User'}"),
              loading: () => CircularProgressIndicator(),
              error: (error, stack) => Text("Error loading data"),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
