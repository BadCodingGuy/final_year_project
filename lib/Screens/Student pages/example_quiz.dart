import 'package:flutter/material.dart';

import 'analytics.dart';

class QuizExample extends StatefulWidget {
  @override
  _QuizExampleState createState() => _QuizExampleState();
}

class _QuizExampleState extends State<QuizExample> {
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  List<bool?> _userResponses = []; // Initialize list to record user responses

  final List<Question> _questions = [
    Question(
      title: 'Question 1: On which line is selection first used?',
      options: ['6', '4', '2', '1'],
      correctAnswerIndex: 2,
      imagePath: 'assets/quiz_images/question 1.png', // Path to the image for Question 1
    ),
    Question(
      title: 'Question 2: What does this flowchart symbol represent?',
      options: ['Input/Output', 'Subroutine', 'Start/Stop', 'Decision'],
      correctAnswerIndex: 1,
      imagePath: 'assets/quiz_images/question 2.png', // Path to the image for Question 2
    ),
    Question(
      title: 'Question 3: What does this flowchart symbol represent?',
      options: ['Subroutine', 'Process', 'Decision', 'Input/Output'],
      correctAnswerIndex: 3,
      imagePath: 'assets/quiz_images/question 3.png', // Path to the image for Question 3
    ),
    Question(
      title: 'Question 4: What does this flowchart symbol represent?',
      options: ['Decision', 'Input/Output', 'Process', 'Subroutine'],
      correctAnswerIndex: 0,
      imagePath: 'assets/quiz_images/question 4.png', // Path to the image for Question 4
    ),
    Question(
      title: 'Question 5: What would this code output if i is 10?',
      options: ['10', '100', '0', '1'],
      correctAnswerIndex: 1,
      imagePath: 'assets/quiz_images/question 5.png', // Path to the image for Question 5
    ),
  ];

  void _handleAnswerSelected(int selectedOptionIndex) {
    // Record whether the selected option is correct
    bool isCorrect = selectedOptionIndex == _questions[_currentQuestionIndex].correctAnswerIndex;
    _userResponses.add(isCorrect);
    if (isCorrect) {
      setState(() {
        _correctAnswers++;
      });
    }
    _showNextQuestion();
  }

  void _showNextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        // Quiz completed, navigate to quiz result screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizResultScreen(
              questions: _questions,
              userResponses: _userResponses,
              correctAnswers: _correctAnswers,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Example'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              _questions[_currentQuestionIndex].title,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Image.asset(
              _questions[_currentQuestionIndex].imagePath, // Path to the image for the current question
              height: 200.0,
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 0.0,
              mainAxisSpacing: 0.0,
              childAspectRatio: 3,
              children: _questions[_currentQuestionIndex].options.asMap().entries.map((entry) {
                final index = entry.key;
                final optionText = entry.value;
                return OptionButton(
                  optionText: optionText,
                  onPressed: () => _handleAnswerSelected(index),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  final String optionText;
  final VoidCallback onPressed;

  const OptionButton({Key? key, required this.optionText, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        optionText,
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }
}

class Question {
  final String title;
  final List<String> options;
  final int correctAnswerIndex;
  final String imagePath; // Path to the image for the question

  Question({
    required this.title,
    required this.options,
    required this.correctAnswerIndex,
    required this.imagePath,
  });
}
