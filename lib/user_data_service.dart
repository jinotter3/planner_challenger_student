import 'package:firebase_database/firebase_database.dart';

class UserDataService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<DatabaseEvent> fetchUserData(String uid) async {
    return await _database.ref().child('users').child(uid).once();
  }
}
