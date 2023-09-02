import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:planner_challenger_student/screens/info_screen.dart';
import 'package:planner_challenger_student/screens/login_screen.dart';
import 'package:planner_challenger_student/screens/signup_screen.dart';
import 'package:planner_challenger_student/screens/splash_screen.dart';

import 'package:firebase_database/firebase_database.dart';

import 'auth.dart';
import 'models/student.dart';
import 'screens/main_screen.dart';

final _key = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>(
  (ref) {
    final authState = ref.watch(authProvider);
    return GoRouter(
      navigatorKey: _key,
      initialLocation: authState.when(
        data: (user) {
          if (user != null) {
            return LoginScreen.routeLocation;
          } else {
            return LoginScreen.routeLocation;
          }
        },
        loading: () => SplashScreen.routeLocation,
        error: (err, stack) => LoginScreen.routeLocation,
      ),
      // redirect: (context, state) {
      //   if (authState.isLoading || authState.hasError) return null;
      //   final isAuth = authState.valueOrNull != null;
      //   if (state.name == LoginScreen.routeName && isAuth) {
      //     if (additionalUserInfoState.isFirstTime() == true) {
      //       return GetDataScreen.routeLocation;
      //     }
      //     return MainScreen.routeLocation;
      //   } else if (state.name != LoginScreen.routeName && !isAuth) {
      //     return LoginScreen.routeLocation;
      //   }
      // },
      routes: [
        GoRoute(
          path: SplashScreen.routeLocation,
          name: SplashScreen.routeName,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: MainScreen.routeLocation,
          name: MainScreen.routeName,
          builder: (context, state) => MainScreen(
            user: state.pathParameters['student'] as User,
            // dateShown: DateTime.now(),
            today: DateTime.now(),
          ),
        ),
        GoRoute(
          path: SignUpScreen.routeLocation,
          name: SignUpScreen.routeName,
          builder: (context, state) => SignUpScreen(),
        ),
        GoRoute(
          path: LoginScreen.routeLocation,
          name: LoginScreen.routeName,
          builder: (context, state) => LoginScreen(),
        ),
        GoRoute(
          path: InfoScreen.routeLocation,
          name: InfoScreen.routeName,
          builder: (context, state) => const InfoScreen(),
        )
      ],
    );
  },
);
