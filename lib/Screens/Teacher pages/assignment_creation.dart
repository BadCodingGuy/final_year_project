import 'package:flutter/material.dart';

class FormativeAssignmentCreation extends StatefulWidget {
  const FormativeAssignmentCreation({Key? key});

  @override
  _FormativeAssignmentCreationState createState() =>
      _FormativeAssignmentCreationState();
}

class _FormativeAssignmentCreationState
    extends State<FormativeAssignmentCreation> {
  int? _selectedOption;
  int? _selectedSubOption;
  double _timeLimit = 5.0; // Default time limit

  Map<String, List<String>> examBoardOptions = {
    'Aqa': [
      'Fundamentals of algorithms',
      'Searching and sorting algorithms',
      'Programming',
      'Programming languages',
      'Further programming language operations',
      'Fundamentals of data representation',
      'Computer systems',
      'Classifying programming languages and translators',
      'Systems architecture',
      'Fundamentals of computer networks',
      'Network topologies, protocols and layers',
      'Fundamentals of cyber security',
      'Ethical, legal and environmental impacts of digital technology'
    ],
    'Edexcel': ['Option 4', 'Option 5', 'Option 6'],
    'Eduqas': ['Option 7', 'Option 8', 'Option 9'],
    'Ocr': ['Option 10', 'Option 11', 'Option 12'],
  };

  Map<String, List<String>> subTopics = {
    'Fundamentals of algorithms': [
      'Algorithm design', 'Algorithm efficiency', 'Recursive algorithms'
    ],
    'Searching and sorting algorithms': [
      'Linear search', 'Binary search', 'Bubble sort', 'Merge sort', 'Quick sort'
    ],
    'Programming languages': [
      'cats', 'Binary search', 'Bubble sort', 'Merge sort', 'Quick sort'
    ],
    // Similarly, add subtopics for other topics
  };

  String _selectedExamBoard = 'Aqa'; // Default exam board
  String _activeExamBoard = 'Aqa'; // Currently active exam board
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

  @override
  Widget build(BuildContext context) {
    List<Widget> examBoardButtons =
    examBoardOptions.keys.map((String examBoard) {
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
    }).toList();

    List<DropdownMenuItem<String>> examBoardDropdownItems =
    examBoardOptions.keys.map((String examBoard) {
      return DropdownMenuItem<String>(
        value: examBoard,
        child: Text(examBoard),
      );
    }).toList();

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
                Wrap(
                  spacing: 10.0,
                  children: examBoardButtons,
                ),
                SizedBox(height: 20.0),
                Text(
                  'What are you teaching today?',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
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
                  items: examBoardOptions[_selectedExamBoard]!.map((String option) {
                    int index = examBoardOptions[_selectedExamBoard]!.indexOf(option);
                    return DropdownMenuItem<String>(
                      value: 'Option ${index + 1}',
                      child: Text(option),
                    );
                  }).toList(),
                ),


                SizedBox(height: 10.0),
                if (_selectedOption != null &&
                    subTopics.containsKey(examBoardOptions[_selectedExamBoard]![_selectedOption! - 1]))
                  DropdownButton<String>(
                    hint: Text('Select a subtopic'),
                    value: _selectedSubOption != null
                        ? 'Suboption ${_selectedSubOption!}'
                        : null,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedSubOption = int.parse(value!.substring(10));
                      });
                    },
                    items: subTopics[examBoardOptions[_selectedExamBoard]![_selectedOption! - 1]]!.map((String suboption) {
                      int index = subTopics[examBoardOptions[_selectedExamBoard]![_selectedOption! - 1]]!.indexOf(suboption);
                      return DropdownMenuItem<String>(
                        value: 'Suboption ${index + 1}',
                        child: Text(suboption),
                      );
                    }).toList(),
                  ),
                SizedBox(height: 20.0),
                Text(
                  'What method are you using?',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    // Add functionality for method button 1
                  },
                  child: Text('Quiz'),
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    // Add functionality for method button 2
                    //b
                  },
                  child: Text('Exit ticket'),
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    // Add functionality for method button 3
                  },
                  child: Text('Interactive'),
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    // Add functionality for method button 4
                  },
                  child: Text('Unplugged'),
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
                          label: _timeLimit.round().toString() + ' minutes',
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
                ElevatedButton(
                  onPressed: () {
                    // Add functionality for create assignment button
                  },
                  child: Text('Create Assignment'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FormativeAssignmentCreation(),
  ));
}
