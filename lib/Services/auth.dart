import 'package:firebase_auth/firebase_auth.dart';

import '../Models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // create user obect based on firebase user
  MyUser? _userfromFirebase(User user){
    return user != null ? MyUser(uid: user.uid):null;
  }

  // auth change user stream to fire
  Stream<MyUser?> get user {
    return _auth.authStateChanges().map((User? user) => _userfromFirebase(user!));
  }
  //sign in anonymous
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userfromFirebase(user!);
    } catch(e){
      print(e.toString());
      return null;
    }
  }
  //sign in with email and password

  //register with email and password

  //sign out
}