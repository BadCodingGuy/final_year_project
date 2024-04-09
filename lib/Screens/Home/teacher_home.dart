import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/Screens/Home/student_settings_form.dart';
import 'package:final_year_project/Screens/Home/teacher_settings_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Services/teacher_auth.dart';
import '../Teacher pages/class_creation_form.dart';

class TeacherHome extends StatelessWidget {
  final TeacherAuthService _auth = TeacherAuthService();

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(context: (context), builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: SettingsForm(),
        );
      });
    }

    void _openClassCreationForm(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return TeacherClassCreationForm();
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('Teacher Home Page'),
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
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('classes').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No classes found.'),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['className']),
                subtitle: Text(data['classDescription']),
                trailing: ElevatedButton(
                  onPressed: () {
                    String classCode = data['classCode'];
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ClassCodeDisplay(classCode)),
                    );
                  },
                  child: Text('Show Class Code'),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openClassCreationForm(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
