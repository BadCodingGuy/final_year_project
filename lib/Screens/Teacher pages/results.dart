import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AnalyticsDisplay extends StatelessWidget {
  final String classCode;

  AnalyticsDisplay({required this.classCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
        backgroundColor: Colors.lightGreen,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('quiz_results')
            .where('classCode', isEqualTo: classCode)
            .snapshots(),
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
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No quiz results found for this class.'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              String studentName = document.id; // Student name is the document ID
              int correctAnswers = data['correct_answers'];
              int totalQuestions = data['total_questions'];
              List<String> userResponses = List<String>.from(data['user_responses'] ?? []);

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
