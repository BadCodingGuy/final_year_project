import 'package:flutter/material.dart';
import '../student_wrapper.dart';
import '../teacher_stream.dart';
import '../teacher_wrapper.dart';


class RoleSelector extends StatefulWidget {
  @override
  _RoleSelectorState createState() => _RoleSelectorState();
}

class _RoleSelectorState extends State<RoleSelector> {
  String selectedUserRole = '';

  void recordUserChoice(String role) {
    setState(() {
      selectedUserRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Role Selection'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: () {
              recordUserChoice('Teacher');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TeacherWrapper()),
              );
            },
            child: Text('Teacher'),
          ),
          ElevatedButton(
            onPressed: () {
              recordUserChoice('Student');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentWrapper()),
              );
            },
            child: Text('Student'),
          ),
        ],
      ),
    );
  }
}
