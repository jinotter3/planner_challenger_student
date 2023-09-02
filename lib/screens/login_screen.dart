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

  _LoginScreen({required this.authService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Login Page"),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (emailController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty) {
                    var loginStudent = await authService.signInWithEmail(
                        email: emailController.text,
                        password: passwordController.text);
                  }
                },
                child: const Text("Login"),
              ),
              ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).go(SignUpScreen.routeLocation);
                },
                child: const Text("Sign Up"),
              )
            ],
          ),
        ),
      ),
    );
  }

  // ... Rest of your login screen implementation ...
}
