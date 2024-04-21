import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Home/student_home.dart';
import '../Home/teacher_home.dart';

class TrafficLightsDisplay extends StatelessWidget {
  final String className;

  TrafficLightsDisplay({required this.className});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[400],
      appBar: AppBar(
        title: Text(
          'Traffic Lights',
          style: TextStyle(
            fontFamily: 'Jersey 10', // Use your font family name here
            fontSize: 30,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TeacherHome()),  // Navigate to Teacher Home page
            );
          },
          child: Image.asset('assets/logo.png', height: 40, width: 40), // Replace with your logo path
        ),
        backgroundColor: Colors.brown[600],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('student_confidence')
            .doc(className)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data available', style: TextStyle(color: Colors.white))); // White text
          }

          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

          List<String> studentNames = List<String>.from(data['studentNames'] ?? []);
          List<String> confidences = List<String>.from(data['confidences'] ?? []);

          return ListView.builder(
            itemCount: studentNames.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  'Student: ${studentNames[index]}',
                  style: TextStyle(color: Colors.white),  // White text
                ),
                subtitle: Text(
                  'Confidence: ${confidences[index]}',
                  style: TextStyle(color: Colors.white),  // White text
                ),
              );
            },
          );
        },
      ),
    );
  }
}
