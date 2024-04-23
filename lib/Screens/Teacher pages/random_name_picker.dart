import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:confetti/confetti.dart';

import '../Home/teacher_home.dart';
import '../../main.dart';

class NamePickerWheel extends StatefulWidget {
  final List<String> students;

  NamePickerWheel({required this.students});

  @override
  _NamePickerWheelState createState() => _NamePickerWheelState();
}

class _NamePickerWheelState extends State<NamePickerWheel> {
  final StreamController<int> controller = StreamController<int>();
  late ConfettiController _confettiController;
  String? selectedStudent;
  bool showConfetti = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    controller.close();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.students.length < 2) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Name Picker Wheel',
            style: TextStyle(
              fontFamily: 'Jersey 10',
              fontSize: 30,
            ),
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TeacherHome()),
              );
            },
            child: Image.asset('assets/logo.png', height: 40, width: 40),
          ),
        ),
        body: Center(
          child: Text('Add more students to spin the wheel.'),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.brown[200],
      appBar: AppBar(
        backgroundColor: Colors.brown[600],
        title: Text(
          'Name Picker Wheel',
          style: TextStyle(
            fontFamily: 'Jersey 10',
            fontSize: 30,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TeacherHome()),
            );
          },
          child: Image.asset('assets/logo.png', height: 40, width: 40),
        ),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            FortuneWheel(
              selected: controller.stream,
              items: [
                for (var student in widget.students)
                  FortuneItem(
                    child: Text(student),
                    style: FortuneItemStyle(
                      textStyle: TextStyle(
                        color: Colors.white, // Text color
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      color: Colors.brown, // Wheel item background color
                      borderColor: Colors.black, // Wheel item border colorBorder color
                      borderWidth: 2, // Border width
                    ),
                  ),
              ],
              onAnimationEnd: () {
                final randomIndex = Random().nextInt(widget.students.length);
                setState(() {
                  selectedStudent = widget.students[randomIndex];
                  showConfetti = true;
                });
                _confettiController.play();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Selected Student'),
                    content: Text(selectedStudent ?? 'No student selected'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
            if (showConfetti)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    key: UniqueKey(),
                    height: MediaQuery.of(context).size.height,
                    child: ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirection: pi / 2,
                      maxBlastForce: 5,
                      minBlastForce: 1,
                      emissionFrequency: 0.03,
                      numberOfParticles: 10,
                      gravity: 0,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (widget.students.isNotEmpty) {
            final randomIndex = Random().nextInt(widget.students.length);
            controller.add(randomIndex);
          }
        },
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
