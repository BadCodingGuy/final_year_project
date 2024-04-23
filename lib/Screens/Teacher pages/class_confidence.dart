import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Home/student_home.dart';
import '../Home/teacher_home.dart';

class TrafficLightsDisplay extends StatelessWidget {
  final String className;

  TrafficLightsDisplay({required this.className});

  Color getColorForConfidence(String confidence) {
    switch (confidence) {
      case 'Red':
        return Colors.red;
      case 'Yellow':
        return Colors.yellow;
      case 'Green':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[400],
      appBar: AppBar(
        title: Text(
          'Traffic Lights',
          style: TextStyle(
            fontFamily: 'Jersey 10',
            fontSize: 30,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TeacherHome()),
            );
          },
          child: Image.asset('assets/logo.png', height: 40, width: 40),
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
            return Center(
              child: Text(
                  'No data available', style: TextStyle(color: Colors.white)),
            );
          }

          Map<String, dynamic>? data = snapshot.data!.data() as Map<
              String,
              dynamic>?;

          if (data == null) {
            return Center(
              child: Text(
                  'No data available', style: TextStyle(color: Colors.white)),
            );
          }

          List<String> studentNames = List<String>.from(
              data['studentNames'] ?? []);
          List<String> confidences = List<String>.from(
              data['confidences'] ?? []);

          return ListView.builder(
            itemCount: studentNames.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  'Student: ${studentNames[index]}',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Row(
                  children: [
                    Text(
                      'Confidence: ',
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
                      Icons.circle,
                      color: getColorForConfidence(confidences[index]),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}