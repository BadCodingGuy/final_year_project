import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../Home/student_home.dart';
import '../main.dart';


class ExampleInteractive extends StatefulWidget {
  @override
  _ExampleInteractiveState createState() => _ExampleInteractiveState();
}

class _ExampleInteractiveState extends State<ExampleInteractive> {
  // Define the code snippets and descriptions for the Parsons problems
  final List<Map<String, dynamic>> problems = [
    {
      'description':
      'Write a program that multiplies a user input number by each number from 1 to 10 and outputs the results.',
      'code': [
        'num ← USERINPUT',
        'FOR number ← 1 TO 10',
        '  OUTPUT number * num',
        'ENDFOR',
      ],
    },
    {
      'description':
      'Description: Write a program that computes the average of three user input numbers and outputs the result.',
      'code': [
        'sum ← 0',
        'FOR i ← 1 TO 3',
        'num ← USERINPUT',
        'sum ← sum + num',
        'ENDFOR',
        'average ← sum / 3',
        'OUTPUT average'

      ],
    },
    {
      'description':
      'Write a program that checks if a user input number is odd or even and outputs the result.',
      'code': [
        'num ← USERINPUT',
        'IF num % 2 == 0',
        'OUTPUT num, " is even"',
        'ELSE',
        'OUTPUT num, " is odd"',
        'ENDIF'

      ],
    },
    {
      'description':
      'Write a program that calculates the factorial of a user input number and outputs the result.',
      'code': [
        'num ← USERINPUT',
        'factorial ← 1',
        'FOR i ← 1 TO num',
        'factorial ← factorial * i',
        'ENDFOR',
        'OUTPUT factorial'
      ],
    },
    {
      'description':
      'Write a program that reverses a user input string and outputs the result.',
      'code': [
        'str ← USERINPUT',
        'reversed ← ""',
        'FOR i ← LENGTH(str) - 1 DOWNTO 0',
        'reversed ← reversed + str[i]',
        'ENDFOR',
        'OUTPUT reversed'
      ],
    },
  ];

  // Define the current problem index
  int currentProblemIndex = 0;

  // Define the number of completed problems
  int completedProblems = 0;

  // Define the shuffled code snippet for the current problem
  List<String> shuffledCodeLines = [];

  // Boolean flag to determine whether to highlight code lines
  bool _showHighlight = false;

  @override
  void initState() {
    super.initState();
    // Start with the first problem
    _loadProblem(0);
  }

  // Load a Parsons problem by index
  void _loadProblem(int index) {
    // Reset shuffled code lines
    shuffledCodeLines = [];

    // Shuffle the code snippet for the current problem
    shuffledCodeLines = List.from(problems[index]['code'])..shuffle();

    // Reset the boolean flag to indicate whether to highlight the code
    setState(() {
      _showHighlight = false;
    });

    // Update the current problem index
    setState(() {
      currentProblemIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[200],
      appBar: AppBar(
        backgroundColor: Colors.brown[600],
        title: Text('Parsons Problem'),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StudentHome()),  // Navigate to Sell page
            );
          },
          child: Image.asset('assets/logo.png', height: 40, width: 40), // Replace with your logo path
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'Problem ${currentProblemIndex + 1}/5:',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              problems[currentProblemIndex]['description'],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 20),
          // Display shuffled code snippet
          Expanded(
            child: ReorderableListView(
              children: _buildCodeLines(_showHighlight),
              onReorder: _onReorder,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _checkCode,
            child: Text('Check Code'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  // Build code lines for the ReorderableListView
  List<Widget> _buildCodeLines(bool showHighlight) {
    List<String> correctCodeLines = problems[currentProblemIndex]['code'];

    return shuffledCodeLines.asMap().entries.map((entry) {
      int index = entry.key;
      String line = entry.value;

      bool isCorrectPosition = line == correctCodeLines[index];

      return Container(
        key: Key(line),
        color: showHighlight && !isCorrectPosition ? Colors.red : Colors.white,
        child: ListTile(
          title: Text(line),
        ),
      );
    }).toList();
  }

  // Handle code line reordering
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final String item = shuffledCodeLines.removeAt(oldIndex);
      shuffledCodeLines.insert(newIndex, item);
    });
  }

  // Check if the code arrangement is correct
  void _checkCode() {
    // Get the correct code snippet for the current problem
    List<String> correctCodeLines = problems[currentProblemIndex]['code'];

    // Check if the arranged code is correct
    bool isCodeCorrect = ListEquality().equals(shuffledCodeLines, correctCodeLines);

    // Update the boolean flag to indicate whether to highlight the code
    setState(() {
      _showHighlight = true;
    });

    // Proceed to the next problem if the code arrangement is correct
    if (isCodeCorrect) {
      // Increment the number of completed problems
      completedProblems++;

      // Show completion message if all problems are completed
      if (completedProblems == 5) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Congratulations!'),
            content: Text('You completed all Parsons problems.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Load the next problem if available
        if (currentProblemIndex + 1 < problems.length) {
          _loadProblem(currentProblemIndex + 1);
        }
      }
    }
  }
}
