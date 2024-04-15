import 'package:flutter/material.dart';

import '../Home/student_home.dart';
import '../main.dart';


class ExampleExitTicket extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exit Ticket',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExitTicketScreen(),
    );
  }
}

class ExitTicketScreen extends StatefulWidget {
  @override
  _ExitTicketScreenState createState() => _ExitTicketScreenState();
}

class _ExitTicketScreenState extends State<ExitTicketScreen> {
  Map<String, String> answers = {};
  int score = 0;

  void checkAnswers() {
    int newScore = 0;

    if (answers['q1'] == 'b') newScore++;
    if (answers['q2'] == 'a') newScore++;
    if (answers['q3'] == 'c') newScore++;
    if (answers['q4'] == 'd') newScore++;
    if (answers['q5'] == 'b') newScore++;

    setState(() {
      score = newScore;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Score'),
          content: Text('You scored $newScore out of 5'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[200],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('Exit Ticket - Pseudocode'),
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Text('1. What is the purpose of pseudocode?',
                style: TextStyle(fontSize: 18.0)),
            RadioListTile(
              title: Text('a) To write production code'),
              value: 'a',
              groupValue: answers['q1'],
              onChanged: (value) {
                setState(() {
                  answers['q1'] = value!;
                });
              },
            ),
            RadioListTile(
              title: Text('b) To plan algorithms'),
              value: 'b',
              groupValue: answers['q1'],
              onChanged: (value) {
                setState(() {
                  answers['q1'] = value!;
                });
              },
            ),
            RadioListTile(
              title: Text('c) To test software'),
              value: 'c',
              groupValue: answers['q1'],
              onChanged: (value) {
                setState(() {
                  answers['q1'] = value!;
                });
              },
            ),
            Text('2. Which symbol represents assignment in pseudocode?',
                style: TextStyle(fontSize: 18.0)),
            RadioListTile(
              title: Text('a) <-'),
              value: 'a',
              groupValue: answers['q2'],
              onChanged: (value) {
                setState(() {
                  answers['q2'] = value!;
                });
              },
            ),
            RadioListTile(
              title: Text('b) ='),
              value: 'b',
              groupValue: answers['q2'],
              onChanged: (value) {
                setState(() {
                  answers['q2'] = value!;
                });
              },
            ),
            RadioListTile(
              title: Text('c) =>'),
              value: 'c',
              groupValue: answers['q2'],
              onChanged: (value) {
                setState(() {
                  answers['q2'] = value!;
                });
              },
            ),
            Text('3. What is a loop in pseudocode?', style: TextStyle(fontSize: 18.0)),
            RadioListTile(
              title: Text('a) A comment'),
              value: 'a',
              groupValue: answers['q3'],
              onChanged: (value) {
                setState(() {
                  answers['q3'] = value!;
                });
              },
            ),
            RadioListTile(
              title: Text('b) A function'),
              value: 'b',
              groupValue: answers['q3'],
              onChanged: (value) {
                setState(() {
                  answers['q3'] = value!;
                });
              },
            ),
            RadioListTile(
              title: Text('c) A repetition structure'),
              value: 'c',
              groupValue: answers['q3'],
              onChanged: (value) {
                setState(() {
                  answers['q3'] = value!;
                });
              },
            ),
            Text('4. Which of the following is a pseudocode convention?',
                style: TextStyle(fontSize: 18.0)),
            RadioListTile(
              title: Text('a) Use of specific programming language syntax'),
              value: 'a',
              groupValue: answers['q4'],
              onChanged: (value) {
                setState(() {
                  answers['q4'] = value!;
                });
              },
            ),
            RadioListTile(
              title: Text('b) Writing code without any structure'),
              value: 'b',
              groupValue: answers['q4'],
              onChanged: (value) {
                setState(() {
                  answers['q4'] = value!;
                });
              },
            ),
            RadioListTile(
              title: Text('c) Using everyday language'),
              value: 'c',
              groupValue: answers['q4'],
              onChanged: (value) {
                setState(() {
                  answers['q4'] = value!;
                });
              },
            ),
            Text('5. What does pseudocode aim to do?', style: TextStyle(fontSize: 18.0)),
            RadioListTile(
              title: Text('a) Implement code directly'),
              value: 'a',
              groupValue: answers['q5'],
              onChanged: (value) {
                setState(() {
                  answers['q5'] = value!;
                });
              },
            ),
            RadioListTile(
              title: Text('b) Plan the logic of a program'),
              value: 'b',
              groupValue: answers['q5'],
              onChanged: (value) {
                setState(() {
                  answers['q5'] = value!;
                });
              },
            ),
            RadioListTile(
              title: Text('c) Debug software'),
              value: 'c',
              groupValue: answers['q5'],
              onChanged: (value) {
                setState(() {
                  answers['q5'] = value!;
                });
              },
            ),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: checkAnswers,
            ),
          ],
        ),
      ),
    );
  }
}
