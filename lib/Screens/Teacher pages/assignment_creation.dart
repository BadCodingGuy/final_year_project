import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Services/countdown_timer.dart';
import '../../Services/topics_database.dart';

class FormativeAssignmentCreation extends StatefulWidget {
  final String classCode; // Add class code as a parameter

  const FormativeAssignmentCreation({Key? key, required this.classCode})
      : super(key: key);

  @override
  _FormativeAssignmentCreationState createState() =>
      _FormativeAssignmentCreationState();
}

class _FormativeAssignmentCreationState
    extends State<FormativeAssignmentCreation> {
  int? _selectedOption;
  int? _selectedSubOption;
  double _timeLimit = 5.0; // Default time limit

  String _selectedExamBoard = 'Aqa'; // Default exam board
  String _activeExamBoard = 'Aqa'; // Currently active exam board
  String? _methodOfAssessment; // Variable to store the selected method

  Color _getThumbColor(double value) {
    if (value <= 10) {
      return Colors.green;
    } else if (value <= 15) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Color _getTrackColor(double value) {
    if (value <= 10) {
      return Colors.green.withOpacity(0.5);
    } else if (value <= 15) {
      return Colors.orange.withOpacity(0.5);
    } else {
      return Colors.red.withOpacity(0.5);
    }
  }

  void _createAssignment(BuildContext context) async {
    try {
      if (_selectedOption == null ||
          _selectedSubOption == null ||
          _methodOfAssessment == null) {
        // Check if any required fields are not selected
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please select all options before creating assignment.'),
        ));
        return;
      }

      // Gather all the necessary data
      String topic = examBoardOptions[_selectedExamBoard]![_selectedOption! - 1];
      String subtopic = subTopics[topic]![_selectedSubOption! - 1];
      double timeLimit = _timeLimit;

      // Create the formative assessment document in Firestore with the document name as the class code
      await FirebaseFirestore.instance.collection('formative_assessments').doc(widget.classCode).set({
        'topic': topic,
        'subtopic': subtopic,
        'methodOfAssessment': _methodOfAssessment,
        'timeLimit': timeLimit,
        // Add additional fields as needed
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Assignment created successfully.'),
      ));
    } catch (error) {
      print('Error creating assignment: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to create assignment. Please try again.'),
      ));
    }
  }

  ElevatedButton _methodButton(String method, Color color) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _methodOfAssessment = method; // Update the selected method
        });
      },
      style: ElevatedButton.styleFrom(
        primary: _methodOfAssessment == method ? color : null, // Change color if selected
      ),
      child: Text(method),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a new formative assessment'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'What exam board are you using?',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                // Exam board selection buttons
                Wrap(
                  spacing: 10.0,
                  children: examBoardOptions.keys.map((String examBoard) {
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedExamBoard = examBoard;
                          _activeExamBoard = examBoard;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: _activeExamBoard == examBoard ? Colors.green : null,
                      ),
                      child: Text(examBoard),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20.0),
                Text(
                  'What are you teaching today?',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                // Dropdown for selecting topic
                DropdownButton<String>(
                  hint: Text('Select a topic'),
                  value: _selectedOption != null ? 'Option ${_selectedOption!}' : null,
                  onChanged: (String? value) {
                    setState(() {
                      if (value != null) {
                        _selectedOption = int.tryParse(value.substring(7));
                        _selectedSubOption = null; // Reset selected subtopic
                      }
                    });
                  },
                  items: examBoardOptions[_selectedExamBoard]!
                      .map((String option) {
                    int index = examBoardOptions[_selectedExamBoard]!.indexOf(option);
                    return DropdownMenuItem<String>(
                      value: 'Option ${index + 1}',
                      child: Text(option),
                    );
                  })
                      .toList(),
                ),
                SizedBox(height: 10.0),
                // Dropdown for selecting subtopic
                if (_selectedOption != null &&
                    subTopics.containsKey(
                        examBoardOptions[_selectedExamBoard]![_selectedOption! - 1]))
                  DropdownButton<String>(
                    hint: Text('Select a subtopic'),
                    value: _selectedSubOption != null ? 'Suboption ${_selectedSubOption!}' : null,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedSubOption = int.parse(value!.substring(10));
                      });
                    },
                    items: subTopics[examBoardOptions[_selectedExamBoard]![_selectedOption! - 1]]!
                        .map((String suboption) {
                      int index = subTopics[examBoardOptions[_selectedExamBoard]![_selectedOption! - 1]]!.indexOf(suboption);
                      return DropdownMenuItem<String>(
                        value: 'Suboption ${index + 1}',
                        child: Text(suboption),
                      );
                    })
                        .toList(),
                  ),
                SizedBox(height: 20.0),
                Text(
                  'What method are you using?',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                // Method selection buttons
                Wrap(
                  spacing: 10.0,
                  children: [
                    _methodButton('Quiz', Colors.green),
                    _methodButton('Exit ticket', Colors.green),
                    _methodButton('Interactive', Colors.green),
                    _methodButton('Unplugged', Colors.green),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'How long is the time limit?',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10.0),
                    // Slider for selecting time limit
                    SizedBox(
                      width: 200.0,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbColor: _getThumbColor(_timeLimit),
                          activeTrackColor: _getTrackColor(_timeLimit),
                        ),
                        child: Slider(
                          value: _timeLimit,
                          min: 1,
                          max: 20,
                          divisions: 19,
                          label: '${_timeLimit.round()} minutes',
                          onChanged: (double value) {
                            setState(() {
                              _timeLimit = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _createAssignment(context), // Create Assignment button
                      child: Text('Create Assignment'),
                    ),
                    SizedBox(width: 10), // Spacer
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CountdownTimerDialog(durationInSeconds: (_timeLimit * 60).toInt());
                          },
                        );
                      },
                      child: Text('Show Timer'), // Button to show timer
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}