import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class AnalyticsDisplay extends StatelessWidget {
  final String classCode;

  AnalyticsDisplay({required this.classCode});

  Map<String, double> computeGradeDistribution(List<QueryDocumentSnapshot> documents) {
    Map<String, int> gradeCounts = {
      '0-1': 0,
      '1-2': 0,
      '2-3': 0,
      '3-4': 0,
      '4-5': 0,
    };

    for (var document in documents) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      int correctAnswers = data['correct_answers'];

      if (correctAnswers >= 0 && correctAnswers <= 1) {
        gradeCounts['0-1'] = (gradeCounts['0-1'] ?? 0) + 1;
      } else if (correctAnswers > 1 && correctAnswers <= 2) {
        gradeCounts['1-2'] = (gradeCounts['1-2'] ?? 0) + 1;
      } else if (correctAnswers > 2 && correctAnswers <= 3) {
        gradeCounts['2-3'] = (gradeCounts['2-3'] ?? 0) + 1;
      } else if (correctAnswers > 3 && correctAnswers <= 4) {
        gradeCounts['3-4'] = (gradeCounts['3-4'] ?? 0) + 1;
      } else if (correctAnswers > 4 && correctAnswers <= 5) {
        gradeCounts['4-5'] = (gradeCounts['4-5'] ?? 0) + 1;
      }
    }

    Map<String, double> gradePercentages = {};

    for (var entry in gradeCounts.entries) {
      gradePercentages[entry.key] = (entry.value / documents.length) * 100;
    }

    return gradePercentages;
  }

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

          Map<String, double> gradeDistribution = computeGradeDistribution(snapshot.data!.docs);

          return Row(
            children: [
              Expanded(
                flex: 2,
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    String studentName = document.id; // Student name is the document ID
                    int correctAnswers = document['correct_answers'];
                    int totalQuestions = document['total_questions'];

                    Color bgColor;
                    if (correctAnswers <= 1) {
                      bgColor = Colors.red[100]!;
                    } else if (correctAnswers <= 2) {
                      bgColor = Colors.orange[100]!;
                    } else if (correctAnswers <= 3) {
                      bgColor = Colors.yellow[100]!;
                    } else if (correctAnswers <= 4) {
                      bgColor = Colors.green[100]!;
                    } else {
                      bgColor = Colors.blue[100]!;
                    }

                    return ListTile(
                      title: Text(studentName),
                      subtitle: Text('Correct Answers: $correctAnswers out of $totalQuestions'),
                      tileColor: bgColor,
                    );
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PieChart(
                    dataMap: gradeDistribution,
                    animationDuration: Duration(milliseconds: 800),
                    chartLegendSpacing: 32.0,
                    chartRadius: MediaQuery.of(context).size.width / 4.0,
                    colorList: [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue],
                    initialAngleInDegree: 0,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 32,
                    legendOptions: LegendOptions(
                      showLegendsInRow: true, // Horizontal legend
                      legendPosition: LegendPosition.bottom,
                      showLegends: true,
                      legendShape: BoxShape.circle,
                      legendTextStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
