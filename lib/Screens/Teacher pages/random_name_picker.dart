import 'dart:math';
import 'package:flutter/material.dart';

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
