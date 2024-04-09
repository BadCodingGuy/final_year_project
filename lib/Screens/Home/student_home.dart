import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/Screens/Home/teacher_settings_form.dart';
import 'package:flutter/material.dart';

import '../../Models/brew.dart';
import '../../Services/student_auth.dart';
import '../../Services/teacher_auth.dart';
import 'package:final_year_project/Services/teacher_auth.dart';
import 'package:provider/provider.dart';

import '../../Services/student_database.dart';
import 'brew_list.dart';

class StudentHome extends StatelessWidget {
  final StudentAuthService _auth = StudentAuthService();
  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(context: (context), builder: (context){
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: SettingsForm(),
        );
      });
    }
    return StreamProvider<List<Brew>?>.value(
      initialData: null,
      value: StudentDatabaseService(uid: "").brews,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(

          title: Text('Student Home Page'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
          ),
            TextButton.icon(
              icon: Icon(Icons.settings),
              label: Text('settings'),
              onPressed: ()  => _showSettingsPanel(),
            ),
      ],
        ),
        body: Container(),
      ),
    );
  }
}
