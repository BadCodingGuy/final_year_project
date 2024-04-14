import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnalyticsDisplay extends StatelessWidget {
  final String classCode;

  AnalyticsDisplay({required this.classCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('Quiz Analytics'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('quiz_results')
            .where('classCode', isEqualTo: classCode)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No quiz results found for this class.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

              String studentName = data['studentName'];
              int correctAnswers = data['correct_answers'];
              int totalQuestions = data['total_questions'];

              return ListTile(
                title: Text(studentName),
                subtitle: Text('Correct Answers: $correctAnswers out of $totalQuestions'),
              );
            },
          );
        },
      ),
    );
  }
}
