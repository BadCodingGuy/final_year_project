import 'package:final_year_project/Screens/Home/teacher_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/student_user.dart';
import '../Models/teacher_user.dart';
import 'Home/role_selection.dart';
import 'Home/student_home.dart';
import 'Student_Authenticate/student_authenticate.dart';

class StudentWrapper extends StatelessWidget {
  const StudentWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<StudentMyUser?>(context);
    //return either home or authenticate widget
    if (user == null){
      return StudentAuthenticate();
    } else {
      return StudentHome();
    }
  }
}
