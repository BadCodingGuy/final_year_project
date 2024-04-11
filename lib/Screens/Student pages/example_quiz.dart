import 'package:flutter/material.dart';

class QuizExample extends StatelessWidget {
  final String title;
  final String imageUrl;
  final List<String> options;

  const QuizExample({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.options,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.brown[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Image.network(
              imageUrl,
              height: 200,
              width: 200,
            ),
            SizedBox(height: 16),
            Column(
              children: options.map((option) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle button press
                      print('Option selected: $option');
                    },
                    child: Text(option),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
