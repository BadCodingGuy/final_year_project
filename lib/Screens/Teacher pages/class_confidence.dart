import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Home/teacher_home.dart';
import '../main.dart';

class ClassConfidenceLevels extends StatelessWidget {
  final String classCode;

  ClassConfidenceLevels({required this.classCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[200],
      appBar: AppBar(
        backgroundColor: Colors.brown[600],
        title: Text('Class Confidence Levels',
          style: TextStyle(
            fontFamily: 'Jersey 10', // Use your font family name here
            fontSize: 30,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TeacherHome()),  // Navigate to Sell page
            );
          },
          child: Image.asset('assets/logo.png', height: 40, width: 40), // Replace with your logo path
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('student_confidence')
            .doc(classCode)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No confidence levels found for this class.'));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;
          List<dynamic>? studentNames = data['studentNames'];
          List<dynamic>? confidences = data['confidences'];

          if (studentNames == null || confidences == null || studentNames.isEmpty || confidences.isEmpty) {
            return Center(child: Text('No confidence levels found for this class.'));
          }

          return ListView.builder(
            itemCount: studentNames.length,
            itemBuilder: (context, index) {
              String studentName = studentNames[index];
              String confidence = confidences[index];

              return ListTile(
                title: Text(studentName),
                subtitle: Text('Confidence: $confidence'),
              );
            },
          );
        },
      ),
    );
  }
}
