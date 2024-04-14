import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pie_chart/pie_chart.dart';

import 'example_quiz.dart';

class QuizResultScreen extends StatelessWidget {
  final List<Question> questions;
  final List<bool?> userResponses;
  final int correctAnswers;

  const QuizResultScreen({
    required this.questions,
    required this.userResponses,
    required this.correctAnswers,
  });

  @override
  Widget build(BuildContext context) {
    int totalQuestions = questions.length;
    double percentage = (correctAnswers / totalQuestions) * 100;

    // Data for the pie chart
    Map<String, double> dataMap = {
      'Correct': correctAnswers.toDouble(),
      'Incorrect': (totalQuestions - correctAnswers).toDouble(),
    };

    List<Color> colorList = [
      Colors.green,
      Colors.red,
    ];

    // Upload quiz results to Firestore
    FirebaseFirestore.instance.collection('quiz_results').add({
      'timestamp': DateTime.now(),
      'correct_answers': correctAnswers,
      'total_questions': totalQuestions,
      'user_responses': userResponses.map((response) => response.toString()).toList(),
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('Quiz Results'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Display the "Number of questions correct" text
          ListTile(
            title: Text('Number of questions correct: $correctAnswers out of $totalQuestions'),
          ),
          // Display the pie chart
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PieChart(
              dataMap: dataMap,
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: 32.0,
              chartRadius: MediaQuery.of(context).size.width / 9.0, // Adjust the chartRadius here
              colorList: colorList,
              initialAngleInDegree: 0,
              chartType: ChartType.ring,
              ringStrokeWidth: 32,
              legendOptions: LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.bottom,
                showLegends: true,
                legendShape: BoxShape.circle,
                legendTextStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Display individual questions and answers
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                final userResponse = userResponses[index];
                final correctAnswerIndex = question.correctAnswerIndex;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      title: Text(
                        question.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                          ),
                          Text('Correct answer: ${question.options[correctAnswerIndex]}'),
                        ],
                      ),
                      trailing: userResponse != null
                          ? (userResponse ? Icon(Icons.check, color: Colors.green) : Icon(Icons.close, color: Colors.red))
                          : Icon(Icons.error, color: Colors.grey),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        height: 100.0,
                        child: Image.asset(
                          question.imagePath,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
