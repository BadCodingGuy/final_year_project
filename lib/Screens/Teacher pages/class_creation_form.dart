import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Services/teacher_auth.dart';
import '../Home/teacher_home.dart';
import '../main.dart';

class TeacherClassCreationForm extends StatefulWidget {
  @override
  _TeacherClassCreationFormState createState() =>
      _TeacherClassCreationFormState();
}

class _TeacherClassCreationFormState extends State<TeacherClassCreationForm> {
  final TextEditingController _classNameController = TextEditingController();
  final TextEditingController _classDescriptionController =
  TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TeacherAuthService _auth = TeacherAuthService();

  void _createClass(BuildContext context) async {
    try {
      String teacherId = _auth.getCurrentUser()?.uid ?? '';
      int classCode =
          DateTime.now().millisecondsSinceEpoch % 10000000;
      // Initialize an empty list of students
      List<String> students = [];

      // Add the class document to Firestore with the document name as the class ID
      await _firestore.collection('classes').doc(classCode.toString()).set({
        'className': _classNameController.text,
        'classDescription': _classDescriptionController.text,
        'classCode': classCode.toString(),
        'teacherId': teacherId,
        'students': students, // Initialize the students field as an empty list
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Class created successfully!')),
      );
    } catch (error) {
      print('Error creating class: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create class. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create Class'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _classNameController,
            decoration: InputDecoration(labelText: 'Class Name'),
          ),
          TextField(
            controller: _classDescriptionController,
            decoration: InputDecoration(labelText: 'Class Description'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          onPressed: () => _createClass(context),
          child: Text('Create'),
        ),
      ],
    );
  }
}

class ClassCodeDisplay extends StatelessWidget {
  final String classCode;

  ClassCodeDisplay(this.classCode);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[200],
      appBar: AppBar(
        backgroundColor: Colors.brown[600],
        title: Text('Class Code'),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Class Code:',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              classCode,
              style: TextStyle(fontSize: 128, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
