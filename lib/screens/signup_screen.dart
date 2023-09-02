import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planner_challenger_student/auth_service.dart';

class SignUpScreen extends ConsumerWidget {
  static String get routeName => 'signup';
  static String get routeLocation => '/$routeName';

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthService authService = AuthService();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            TextField(
              controller: passwordConfirmController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm Password'),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: studentIdController,
              decoration: InputDecoration(labelText: 'Student ID'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (emailController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty &&
                    passwordConfirmController.text.isNotEmpty &&
                    nameController.text.isNotEmpty &&
                    studentIdController.text.isNotEmpty &&
                    passwordController.text == passwordConfirmController.text) {
                  await authService.signUpWithEmail(
                      email: emailController.text,
                      password: passwordController.text,
                      name: nameController.text,
                      studentId: studentIdController.text);
                } else {
                  print("Fill all fields!");
                }
              },
              child: Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
