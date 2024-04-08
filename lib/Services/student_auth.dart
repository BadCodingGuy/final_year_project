import 'package:final_year_project/Services/teacher_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Models/student_user.dart';
import '../Models/teacher_user.dart';
import 'student_database.dart';

class StudentAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StudentMyUser? _userfromFirebase(User user) {
    return user != null ? StudentMyUser(uid: user.uid) : null;
  }

  Stream<StudentMyUser?> get user {
    return _auth.authStateChanges().map((User? user) => _userfromFirebase(user!));
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userfromFirebase(user!);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      // Pass the UID to updateUserData method
      await StudentDatabaseService(uid: user!.uid).updateUserData('0', 'new crew member', 100);

      return _userfromFirebase(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}
