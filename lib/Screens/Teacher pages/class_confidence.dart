import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClassConfidenceLevels extends StatelessWidget {
  final String classCode;

  ClassConfidenceLevels({required this.classCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Class Confidence Levels'),
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
