import 'package:flutter/material.dart';
import 'package:final_year_project/Services/student_auth.dart';
import 'package:final_year_project/Models/brew.dart';
import 'package:final_year_project/Services/student_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class StudentHome extends StatelessWidget {
  final StudentAuthService _auth = StudentAuthService();
  final TextEditingController _classCodeController = TextEditingController();


  Future<void> _joinClass(BuildContext context) async {
    String classCode = _classCodeController.text.trim();
    String? studentName = (await _auth.getCurrentUserInfo())['studentName'];

    if (classCode.isNotEmpty) {
      final QuerySnapshot classSnapshot = await FirebaseFirestore.instance
          .collection('classes')
          .where('classCode', isEqualTo: classCode)
          .limit(1)
          .get();

      if (classSnapshot.docs.isNotEmpty) {
        // Class with the entered code exists
        String className = classSnapshot.docs.first.get('className');
        String classId = classSnapshot.docs.first.id;

        // Update the class document to add the student's name
        await FirebaseFirestore.instance.collection('classes').doc(classId).update({
          'students': FieldValue.arrayUnion([studentName]),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Joined $className successfully!')),
        );
      } else {
        // Class with the entered code does not exist
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Class with code $classCode does not exist!')),
        );
      }
    } else {
      // No class code entered
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a class code!')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Brew>?>.value(
      initialData: null,
      value: StudentDatabaseService(uid: "").brews,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Student Home Page'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person),
              label: Text('Logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _classCodeController,
                decoration: InputDecoration(
                  labelText: 'Enter Class Code',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _joinClass(context),
                child: Text('Join Class'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
