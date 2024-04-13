import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Services/student_auth.dart';

class TrafficLightsSelection extends StatefulWidget {
  final String classCode;

  TrafficLightsSelection({required this.classCode});

  @override
  _TrafficLightsSelectionState createState() => _TrafficLightsSelectionState();
}

class _TrafficLightsSelectionState extends State<TrafficLightsSelection> {
  String? _selectedColor;

  void _saveChoice(BuildContext context) async {
    try {
      var userInfo = await StudentAuthService().getCurrentUserInfo();
      print('User Info: $userInfo'); // Debug print

      String? studentName = userInfo['studentName'];
      print('Student Name: $studentName'); // Debug print

      print('Class Code: ${widget.classCode}'); // Debug print

      if (studentName != null && _selectedColor != null) {
        DocumentReference docRef = FirebaseFirestore.instance
            .collection('student_confidence')
            .doc(widget.classCode);

        // Use set with SetOptions to merge data or create new document
        await docRef.set({
          'studentNames': FieldValue.arrayUnion([studentName]),
          'confidences': FieldValue.arrayUnion([_selectedColor]),
        }, SetOptions(merge: true)); // Merge data with existing document or create new document

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Choice saved successfully!')),
        );
      } else {
        print('Student name or selected color is null'); // Debug print
      }
    } catch (e) {
      print('Error fetching or updating user info: $e'); // Debug print
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Traffic Lights'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RadioListTile<String>(
            title: Text('Green'),
            value: 'Green',
            groupValue: _selectedColor,
            onChanged: (value) {
              print('Selected Color: $value'); // Debug print
              setState(() => _selectedColor = value);
            },
          ),
          RadioListTile<String>(
            title: Text('Yellow'),
            value: 'Yellow',
            groupValue: _selectedColor,
            onChanged: (value) {
              print('Selected Color: $value'); // Debug print
              setState(() => _selectedColor = value);
            },
          ),
          RadioListTile<String>(
            title: Text('Red'),
            value: 'Red',
            groupValue: _selectedColor,
            onChanged: (value) {
              print('Selected Color: $value'); // Debug print
              setState(() => _selectedColor = value);
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _saveChoice(context), // Save button
            child: Text('Save Choice'),
          ),
        ],
      ),
    );
  }
}
