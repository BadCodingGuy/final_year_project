import 'package:flutter/material.dart';


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
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('Unplugged activity'),
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
