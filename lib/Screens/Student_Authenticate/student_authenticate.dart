import 'package:final_year_project/Screens/Student_Authenticate/student_register.dart';
import 'package:final_year_project/Screens/Student_Authenticate/student_sign_in.dart';
import 'package:flutter/material.dart';

class StudentAuthenticate extends StatefulWidget {
  const StudentAuthenticate({Key? key}) : super(key: key);

  @override
  State<StudentAuthenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<StudentAuthenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }
  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return StudentSignIn(toggleView: toggleView);
    } else {
      return StudentRegister(toggleView: toggleView);
    }
  }
}

