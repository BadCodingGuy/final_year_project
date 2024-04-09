import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/Services/teacher_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Models/student_user.dart';
import '../Models/teacher_user.dart';
import 'student_database.dart';

class StudentAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to get the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
  Future<Map<String, String>> getCurrentUserInfo() async {
    Map<String, String> userInfo = {'userId': '', 'studentName': ''};
    User? user = _auth.currentUser;

    if (user != null) {
      userInfo['userId'] = user.uid;

      // Here, you would retrieve the student's name from your database
      // For example, if you're using Firestore:
      // Replace 'yourStudentCollection' with your actual collection name
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Student')
          .doc(user.uid)
          .get();

      // Assuming your student's name is stored in a field named 'name'
      if (snapshot.exists) {
        userInfo['studentName'] = snapshot.get('name');
      }
    }

    return userInfo;
  }

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
      await StudentDatabaseService(uid: user!.uid).updateUserData('Student', 'Email');

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
