import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Services/teacher_auth.dart';
import 'Home/teacher_home.dart';

class TeachersStream extends StatelessWidget {
  const TeachersStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      catchError: (_, __) => null,
      value: TeacherAuthService().user,
      initialData: null,
      child: MaterialApp(
        home: TeacherHome(
        ),
      ),
    );
  }
}