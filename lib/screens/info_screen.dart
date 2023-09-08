import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:planner_challenger_student/auth.dart';
import 'package:planner_challenger_student/auth_service.dart';
import 'package:planner_challenger_student/components/student-rank-card.dart';
import 'package:planner_challenger_student/screens/login_screen.dart';
import 'package:planner_challenger_student/screens/main_screen.dart';

class InfoScreen extends ConsumerWidget {
  final AuthService _authService = AuthService();
  InfoScreen({
    super.key,
  });
  static String get routeName => 'info';
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
            return _InfoScreen(user: user);
          }
        },
        loading: () => CircularProgressIndicator(),
        error: (_, __) => Text('Error occurred!'),
      ),
    );
  }
}

class _InfoScreen extends StatefulWidget {
  const _InfoScreen({super.key, required this.user});
  final User user;

  @override
  State<_InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<_InfoScreen> {
  Query dbref = FirebaseDatabase.instance
      .ref()
      .child("students")
      .orderByChild('info/studentId');

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("랭킹",
    //         style: TextStyle(
    //             fontSize: 24,
    //             fontWeight: FontWeight.bold,
    //             color: Colors.white)),
    //     backgroundColor: Colors.blue,
    //     actions: [
    //       IconButton(
    //           onPressed: () {
    //             GoRouter.of(context).go(MainScreen.routeLocation);
    //           },
    //           icon: Icon(Icons.home),
    //           color: Colors.white),
    //       IconButton(
    //         icon: Icon(Icons.logout),
    //         color: Colors.white,
    //         onPressed: () async {
    //           await FirebaseAuth.instance.signOut();
    //         },
    //       ),
    //     ],
    //   ),
    //   body: Center(child: Text("구현하려고 노력중입니다")),
    // );
    return Scaffold(
        appBar: AppBar(
          title: Text("랭킹",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
                onPressed: () {
                  GoRouter.of(context).go(MainScreen.routeLocation);
                },
                icon: Icon(Icons.home),
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
                child: FirebaseAnimatedList(
              query: dbref,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                Map student = snapshot.value as Map;
                print(student);
                return StudentRankCard(student: student);
              },
            ),
            ),
          ],
        ));
  }
}
