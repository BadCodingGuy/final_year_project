import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Services/teacher_auth.dart';

class TeacherClassCreationForm extends StatefulWidget {
  @override
  _TeacherClassCreationFormState createState() => _TeacherClassCreationFormState();
}

class _TeacherClassCreationFormState extends State<TeacherClassCreationForm> {
  final TextEditingController _classNameController = TextEditingController();
  final TextEditingController _classDescriptionController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TeacherAuthService _auth = TeacherAuthService();

  void _createClass(BuildContext context) async {
    try {
      String teacherId = _auth.getCurrentUser()?.uid ?? '';
      int classCode = DateTime.now().millisecondsSinceEpoch % 10000000;
      // Initialize an empty list of students
      List<String> students = [];

      // Add the class document to Firestore with the students field initialized as an empty list
      DocumentReference classRef = await _firestore.collection('classes').add({
        'className': _classNameController.text,
        'classDescription': _classDescriptionController.text,
        'classCode': classCode.toString(),
        'teacherId': teacherId,
        'students': students, // Initialize the students field as an empty list
      });

      // Get the ID of the newly created class document
      String classId = classRef.id;

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
    appBar: AppBar(
      title: Text('Class Code'),
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
