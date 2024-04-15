import 'package:flutter/material.dart';

import '../Home/student_home.dart';
import '../main.dart';


class ExampleUnplugged extends StatelessWidget {
  final List<String> imageNames = [
    'assets/unplugged/unplugged 1.png',
    'assets/unplugged/unplugged 2.png',
    'assets/unplugged/unplugged 3.png',
    'assets/unplugged/unplugged 4.png',
    'assets/unplugged/unplugged 5.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[200],
      appBar: AppBar(
        backgroundColor: Colors.brown[600],
        title: Text('Unplugged activity'),
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
      body: ListView.builder(
        itemCount: imageNames.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              imageNames[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
