import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Services/teacher_auth.dart';
import '../Student pages/traffic_lights.dart';
import '../Teacher pages/class_confidence.dart';
import '../Teacher pages/class_creation_form.dart';
import '../Teacher pages/assignment_creation.dart';

class TeacherHome extends StatelessWidget {
  final TeacherAuthService _auth = TeacherAuthService();

  @override
  Widget build(BuildContext context) {

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
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['className']),
                subtitle: Text(data['classDescription']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        String classCode = data['classCode']; // Retrieve class code from data
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FormativeAssignmentCreation(classCode: classCode),
                          ),
                        );
                      },
                      child: Text('Create Formative Assessment'),
                    ),
                    SizedBox(width: 8), // Add some spacing between buttons
                    ElevatedButton(
                      onPressed: () {
                        // Add your logic to view analytics
                        // This could be a dialog, navigation, or any other method you prefer
                      },
                      child: Text('View Analytics'),
                    ),
                    SizedBox(width: 8), // Add some spacing between buttons
                    ElevatedButton(
                      onPressed: () {
                        String classCode = data['classCode']; // Retrieve class code from data
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClassCodeDisplay(classCode),
                          ),
                        );
                      },
                      child: Text('Show Class Code'),
                    ),
                    SizedBox(width: 8), // Add some spacing between buttons
                    ElevatedButton(
                      onPressed: () {
                        String classCode = data['classCode']; // Retrieve class code from data
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClassConfidenceLevels(classCode: classCode), // Navigate to ClassConfidenceLevels widget
                          ),
                        );
                      },
                      child: Text('Traffic Lights'),
                    ),
                  ],
                ),
              );
            },
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
