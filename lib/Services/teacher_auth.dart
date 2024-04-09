import 'package:final_year_project/Services/teacher_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Models/teacher_user.dart';
import 'student_database.dart';

class TeacherAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  TeacherMyUser? _userfromFirebase(User user) {
    return user != null ? TeacherMyUser(uid: user.uid) : null;
  }

  Stream<TeacherMyUser?> get user {
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

  Future registerWithEmailAndPassword(String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      // Pass the actual name and email values to updateUserData method
      await TeacherDatabaseService(uid: user!.uid).updateUserData(name, email);

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
