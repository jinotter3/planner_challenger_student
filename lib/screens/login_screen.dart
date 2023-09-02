import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:go_router/go_router.dart';
import 'package:planner_challenger_student/screens/main_screen.dart';
import '../auth.dart';
import '../auth_service.dart';
import '../models/student.dart';
import 'signup_screen.dart';

class LoginScreen extends ConsumerWidget {
  final AuthService _authService = AuthService();
  static String get routeName => 'login';
  static String get routeLocation => '/$routeName';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: authState.when(
        data: (user) {
          if (user == null) {
            return _LoginScreen(authService: _authService);
          } else {
            return MainScreen(
              user: user,
              dateShown: DateTime.now(),
              today: DateTime.now(),
            );
          }
        },
        loading: () => CircularProgressIndicator(),
        error: (_, __) => Text('Error occurred!'),
      ),
    );
  }
}

class _LoginScreen extends StatelessWidget {
  final AuthService authService;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _LoginScreen({required this.authService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: 420,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(),
                      const Text("Login Page"),
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
                        decoration: const InputDecoration(labelText: 'Email'),
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
                        decoration: const InputDecoration(labelText: 'Password'),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          try {
                            await authService.signInWithEmail(
                                email: emailController.text,
                                password: passwordController.text);
                          } catch (error) {
                            if (error
                                .toString()
                                .startsWith('[firebase_auth/wrong-password]')) {
                              // ignore: use_build_context_synchronously
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("로그인 실패"),
                                    content: Text("비밀번호 오류"),
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
                            } else if (error
                                .toString()
                                .startsWith('[firebase_auth/user-not-found]')) {
                              // ignore: use_build_context_synchronously
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("로그인 실패"),
                                    content: Text("존재하지 않는 이메일입니다"),
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
                            } else {
                              // ignore: use_build_context_synchronously
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("로그인 실패"),
                                    content: Text("알 수 없는 오류"),
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
                        },
                        child: const Text("Login"),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          GoRouter.of(context).go(SignUpScreen.routeLocation);
                        },
                        child: const Text("Sign Up"),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ... Rest of your login screen implementation ...
}
