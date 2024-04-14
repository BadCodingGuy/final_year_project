import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Services/teacher_auth.dart';
import '../Student pages/traffic_lights.dart';
import '../Teacher pages/class_confidence.dart';
import '../Teacher pages/class_creation_form.dart';
import '../Teacher pages/assignment_creation.dart';
import '../Teacher pages/random_name_picker.dart';
import '../Teacher pages/results.dart';

class RandomStudentSelection extends StatelessWidget {
  final List<String> students;

  RandomStudentSelection({required this.students});

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) {
      return AlertDialog(
        title: Text('No students found'),
        content: Text('There are no students in this class.'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    }

    Random random = Random();
    int randomIndex = random.nextInt(students.length);
    String selectedStudent = students[randomIndex];

    return AlertDialog(
      title: Text('Randomly Selected Student'),
      content: Text('Selected Student: $selectedStudent'),
      actions: [
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class TeacherHome extends StatelessWidget {
  final TeacherAuthService _auth = TeacherAuthService();

  void _openClassCreationForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TeacherClassCreationForm();
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('Teacher Home Page'),
        backgroundColor: Colors.lightGreen,
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(
              Icons.person,
              color: Colors.white, // Set icon color to white
            ),
            label: Text(
              'logout',
              style: TextStyle(
                color: Colors.white, // Set text color to white
              ),
            ),
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
              String className = data['className']; // Retrieve class name from data
              List<String> students = List<String>.from(data['students'] ?? []); // Retrieve students from data

              return ListTile(
                title: Text(className),
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
                        String classCode = data['classCode']; // Retrieve class code from data
                        print(classCode);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnalyticsDisplay(classCode: classCode),
                          ),
                        );
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
                            builder: (context) => ClassConfidenceLevels(classCode: classCode),
                          ),
                        );
                      },
                      child: Text('Traffic Lights'),
                    ),
                    SizedBox(width: 8), // Add some spacing between buttons
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NamePickerWheel(students: students),
                          ),
                        );
                      },
                      child: Text('Choose Student'),
                    ),
                    SizedBox(width: 8), // Add some spacing between buttons
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete Class'),
                              content: Text('Are you sure you want to delete $className?'),
                              actions: [
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: Text('Delete'),
                                  onPressed: () async {
                                    // Delete the class from Firestore
                                    await FirebaseFirestore.instance.collection('classes').doc(document.id).delete();
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('$className deleted successfully!')),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Delete'),
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
