import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Services/countdown_timer.dart';
import '../../Services/topics_database.dart';
import '../Home/teacher_home.dart';
import '../main.dart';

class FormativeAssignmentCreation extends StatefulWidget {
  final String classCode;

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
  double _timeLimit = 5.0;

  String _selectedExamBoard = 'Aqa';
  String _activeExamBoard = 'Aqa';
  String? _methodOfAssessment;

  late AudioPlayer _audioPlayer;
  bool _showPartyBackground = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  Future<void> _playMusic() async {
    final player = AudioPlayer();
    await player.play(UrlSource('assets/audio/Chicago - Freedom Trail Studio.mp3'));
    setState(() {
      _audioPlayer = player;
    });
  }

  void _showCountdownTimerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CountdownTimerDialog(durationInSeconds: _timeLimit.toInt() * 60); // Convert minutes to seconds
      },
    );
  }


  Future<void> _stopMusic() async {
    if (_audioPlayer != null) {
      await _audioPlayer.stop();
    }
  }


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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please select all options before creating assignment.'),
        ));
        return;
      }


      String topic = examBoardOptions[_selectedExamBoard]![_selectedOption! - 1];
      String subtopic = subTopics[topic]![_selectedSubOption! - 1];
      double timeLimit = _timeLimit;

      await FirebaseFirestore.instance
          .collection('formative_assessments')
          .doc(widget.classCode)
          .set({
        'topic': topic,
        'subtopic': subtopic,
        'methodOfAssessment': _methodOfAssessment,
        'timeLimit': timeLimit,
      });

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
          _methodOfAssessment = method;
        });
      },
      style: ElevatedButton.styleFrom(
        primary: _methodOfAssessment == method ? color : Colors.brown,
      ),
      child: Text(method),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[200],
      appBar: AppBar(
        backgroundColor: Colors.brown[600],
        title: Text('Create a new formative assessment',
          style: TextStyle(
            fontFamily: 'Jersey 10', // Use your font family name here
            fontSize: 30,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TeacherHome()),  // Navigate to Sell page
            );
          },
          child: Image.asset('assets/logo.png', height: 40, width: 40), // Replace with your logo path
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_showPartyBackground)
            Image.asset(
              'assets/shapes.gif',
              fit: BoxFit.cover,
            ),
          Center(
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
                      children: examBoardOptions.keys.map((String examBoard) {
                        return ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedExamBoard = examBoard;
                              _activeExamBoard = examBoard;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: _activeExamBoard == examBoard ? Colors.blue : Colors.brown,
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
                    DropdownButton<String>(
                      hint: Text('Select a topic'),
                      value: _selectedOption != null ? 'Option ${_selectedOption!}' : null,
                      onChanged: (String? value) {
                        setState(() {
                          if (value != null) {
                            _selectedOption = int.tryParse(value.substring(7));
                            _selectedSubOption = null;
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
                    if (_selectedOption != null &&
                        subTopics.containsKey(examBoardOptions[_selectedExamBoard]![_selectedOption! - 1]))
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
                    Wrap(
                      spacing: 10.0,
                      children: [
                        _methodButton('Quiz', Colors.blue),
                        _methodButton('Exit ticket', Colors.blue),
                        _methodButton('Interactive', Colors.blue),
                        _methodButton('Unplugged', Colors.blue),
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
                    ElevatedButton(
                      onPressed: () => _createAssignment(context),
                      child: Text('Create Assignment'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.brown,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        _showCountdownTimerDialog(context);
                      },
                      child: Text('Show Countdown Timer'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.brown,
                      ),
                    ),


                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Party! 🎉'),
                        ));
                        setState(() {
                          _showPartyBackground = !_showPartyBackground;
                        });
                        _playMusic();
                      },

                      child: Text('Party mode', style: TextStyle(fontSize: 18.0)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.brown,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ElevatedButton( // Stop Music Button
                      onPressed: _stopMusic,
                      child: Text('Stop Music', style: TextStyle(fontSize: 18.0)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.brown,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
