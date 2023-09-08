import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:planner_challenger_student/auth_service.dart';
import 'package:planner_challenger_student/screens/login_screen.dart';

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
  isNum(String num) {
    try {
      int.parse(num);
      return true;
    } catch (e) {
      return false;
    }
  }

  signup(context) async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await authService.signUpWithEmail(
          email: emailController.text,
          password: passwordController.text,
          name: nameController.text,
          studentId: studentIdController.text);
      GoRouter.of(context).go(LoginScreen.routeLocation);
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
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [
            Color(0xff0066FF).withOpacity(0.6),
            Color(0xffC566FF).withOpacity(0.5),
          ],
        )),
        child: Center(
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
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                      onFieldSubmitted: (value) {
                        signup(context);
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
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      decoration: const InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                      onFieldSubmitted: (value) {
                        signup(context);
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
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                      onFieldSubmitted: (value) {
                        signup(context);
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
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      decoration: const InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                      onFieldSubmitted: (value) {
                        signup(context);
                      },
                    ),
                    TextFormField(
                      controller: studentIdController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '문항 수를 입력해주세요';
                        }
                        //is value is int
                        else if (isNum(value) == false) {
                          return '문항 수는 숫자로 입력해주세요';
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      decoration: const InputDecoration(
                            labelText: 'Student ID',
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                      onFieldSubmitted: (value) {
                        signup(context);
                      },
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        signup(context);
                      },
                      child: Text("Sign Up"),
                      style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            onPrimary: Colors.white,
                          ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
