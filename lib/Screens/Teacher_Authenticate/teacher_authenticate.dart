import 'package:final_year_project/Screens/Teacher_Authenticate/teacher_register.dart';
import 'package:final_year_project/Screens/Teacher_Authenticate/teacher_sign_in.dart';
import 'package:flutter/material.dart';

class TeacherAuthenticate extends StatefulWidget {
  const TeacherAuthenticate({Key? key}) : super(key: key);

  @override
  State<TeacherAuthenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<TeacherAuthenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }
  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return TeacherSignIn(toggleView: toggleView);
    } else {
      return TeacherRegister(toggleView: toggleView);
    }
  }
}

