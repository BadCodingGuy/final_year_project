import 'package:flutter/material.dart';

import 'package:flutter/material.dart';


class RoleSelector extends StatefulWidget {
  @override
  _RoleSelectorState createState() => _RoleSelectorState();
}

class _RoleSelectorState extends State<RoleSelector> {
  String selectedUserRole = '';

  String recordUserChoice(String role) {
    setState(() {
      selectedUserRole = role;
    });
    return role;
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
            onPressed: () => recordUserChoice('Teacher'),
            child: Text('Teacher'),
          ),
          ElevatedButton(
            onPressed: () => recordUserChoice('Student'),
            child: Text('Student'),
          ),
        ],
      ),
    );
  }
}
