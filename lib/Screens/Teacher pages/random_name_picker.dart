import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:confetti/confetti.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Name Picker Wheel'),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            FortuneWheel(
              selected: controller.stream,
              items: [
                for (var student in widget.students) FortuneItem(child: Text(student)),
              ],
              onAnimationEnd: () {
                // Generate a random index and update the selectedStudent
                final randomIndex = Random().nextInt(widget.students.length);
                setState(() {
                  selectedStudent = widget.students[randomIndex];
                  showConfetti = true;
                });

                // Show confetti and selected student name
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
            // Generate a random index and add it to the stream
            final randomIndex = Random().nextInt(widget.students.length);
            controller.add(randomIndex);
          }
        },
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}