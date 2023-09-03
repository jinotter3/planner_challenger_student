import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planner_challenger_student/auth_service.dart';

class SignUpScreen extends ConsumerWidget {
  final AuthService authService = AuthService();
  static String get routeName => 'signup';
  static String get routeLocation => '/$routeName';

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  signin(context) async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await authService.signUpWithEmail(
          email: emailController.text,
          password: passwordController.text,
          name: nameController.text,
          studentId: studentIdController.text);
    } catch (e) {
      if (e.toString().startsWith('[firebase_auth/email-already-in-use]')) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("회원가입 실패"),
              content: Text("이미 존재하는 이메일입니다"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("확인")),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: 420,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Spacer(),
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (EmailValidator.validate(value) == false) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Email'),
                    onFieldSubmitted: (value){
                      signin(context);
                    },
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Password'),
                    onFieldSubmitted: (value) {
                      signin(context);
                    },
                  ),
                  TextFormField(
                    controller: passwordConfirmController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      } else if (value != passwordController.text) {
                        return 'Password does not match';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    onFieldSubmitted: (value) {
                      signin(context);
                    },
                  ),
                  TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Name'),
                    onFieldSubmitted: (value){
                      signin(context);
                    },
                  ),
                  TextFormField(
                    controller: studentIdController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your student ID';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Student ID'),
                    onFieldSubmitted: (value){
                      signin(context);
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      signin(context);
                    },
                    child: Text("Sign Up"),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
