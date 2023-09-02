// auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:planner_challenger_student/models/student.dart';
import 'auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var database = FirebaseDatabase.instance.ref();

  Future<void> signUpWithEmail(
      {required String email,
      required String password,
      required String name,
      required String studentId}) async {
    final auth = FirebaseAuth.instance;

    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    print(userCredential.user!.uid);

    // After signing up, create a field in Realtime Database
    final databaseReference = FirebaseDatabase.instance.ref();
    await databaseReference.child('students/${userCredential.user!.uid}').set({
      "info": {
        "name": name,
        "studentId": studentId,
        "id": userCredential.user!.uid,
      },
      "dday": [],
      "days": [],
    });
  }

  Future<Student> signInWithEmail(
      {required String email, required String password}) async {
    final auth = FirebaseAuth.instance;

    UserCredential userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    // After signing in, fetch additional user data from Realtime Database
    final databaseReference = FirebaseDatabase.instance.ref();
    await databaseReference
        .child('students/${userCredential.user!.uid}/info')
        .once()
        .then((DatabaseEvent value) {
      print(value.snapshot.value);
      // update user info
      final map = value.snapshot.value as Map<dynamic, dynamic>;
      Student student = Student(
        name: map['name'],
        studentId: map['studentId'],
        id: map['id'],
      );
    });
    return Student(
      name: '',
      studentId: '',
      id: '',
    );
  }

  // google sign in
  Future<User?> signInWithGoogle() async {
    try {
      final googleUser = await _auth.signInWithPopup(
        GoogleAuthProvider().addScope('email'),
      );
      return googleUser.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // get user id
  Future<String?> getUserId() async {
    try {
      final user = _auth.currentUser;
      return user!.uid;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // TODO: Add registration, sign out, and other methods as needed
}
