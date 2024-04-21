import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:audioplayers/audioplayers.dart';

class CountdownTimerDialog extends StatelessWidget {
  final int durationInSeconds; // Duration of the countdown timer in seconds

  const CountdownTimerDialog({Key? key, required this.durationInSeconds})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime endTime = DateTime.now().add(Duration(seconds: durationInSeconds));

    return AlertDialog(
      title: Text('Time left!'),
      content: Container(
        height: 100, // Adjust the height as needed
        child: Center(
          child: TimerCountdown(
            format: CountDownTimerFormat.minutesSeconds,
            endTime: endTime,
            onEnd: () {
              _playAlarm(); // Play alarm sound when timer ends
              Navigator.pop(
                  context); // Close the dialog when the timer finishes
            },
          ),
        ),
      ),
    );
  }

  void _playAlarm() async {
    final player = AudioPlayer();
    await player.play(UrlSource('assets/audio/alarm.mp3'));
  }
}
