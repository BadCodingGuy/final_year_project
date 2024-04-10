import 'package:final_year_project/Screens/Home/teacher_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/teacher_user.dart';
import 'Home/role_selection.dart';
import 'Student_Authenticate/student_authenticate.dart';
import 'Teacher_Authenticate/teacher_authenticate.dart';

class TeacherWrapper extends StatelessWidget {
  const TeacherWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TeacherMyUser?>(context);
    //return either home or authenticate widget
    if (user == null){
      return TeacherAuthenticate();
    } else {
      return TeacherHome();
    }
  }
}
