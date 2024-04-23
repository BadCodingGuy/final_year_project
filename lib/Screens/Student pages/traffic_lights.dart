import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Services/student_auth.dart';
import '../Home/student_home.dart';
import '../../main.dart';

class TrafficLightsSelection extends StatefulWidget {
  final String classCode;

  TrafficLightsSelection({required this.classCode});

  @override
  _TrafficLightsSelectionState createState() => _TrafficLightsSelectionState();
}

class _TrafficLightsSelectionState extends State<TrafficLightsSelection> {
  String? _selectedColor;

  Future<void> _saveChoice(BuildContext context) async {
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

        // Fetch current studentNames and confidences arrays
        DocumentSnapshot snapshot = await docRef.get();

        if (snapshot.exists) {
          List<dynamic>? studentNames = List.from(snapshot['studentNames'] ?? []);
          List<dynamic>? confidences = List.from(snapshot['confidences'] ?? []);

          if (studentNames != null && confidences != null) {
            int index = studentNames.indexOf(studentName);

            if (index != -1) {
              // Update confidence value at the found index
              confidences[index] = _selectedColor;

              await docRef.update({
                'confidences': confidences,
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Choice saved successfully!')),
              );
            } else {
              // If student not found, add the student and confidence
              studentNames.add(studentName);
              confidences.add(_selectedColor);

              await docRef.update({
                'studentNames': studentNames,
                'confidences': confidences,
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Student added and choice saved successfully!')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error fetching data!')),
            );
          }
        } else {
          // If the document doesn't exist, create it with initial data
          await docRef.set({
            'studentNames': [studentName],
            'confidences': [_selectedColor],
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Choice saved successfully!')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a color!')),
        );
      }
    } catch (e) {
      print('Error fetching or updating user info: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[200],
      appBar: AppBar(
        backgroundColor: Colors.brown[600],
        title: Text(
          'Traffic Lights',
          style: TextStyle(
            fontFamily: 'Jersey 10',
            fontSize: 30,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StudentHome()),
            );
          },
          child: Image.asset('assets/logo.png', height: 40, width: 40),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Left Half: Traffic Lights Image
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Image.asset(
                      'assets/traffic_lights.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            // Right Half: Radio Buttons and Save Button
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RadioListTile<String>(
                          title: Text('Red', style: TextStyle(fontSize: 24.0)),
                          value: 'Red',
                          groupValue: _selectedColor,
                          onChanged: (value) {
                            print('Selected Color: $value');
                            setState(() => _selectedColor = value);
                          },
                          activeColor: Colors.red,
                        ),
                        SizedBox(height: 12),
                        RadioListTile<String>(
                          title: Text('Yellow', style: TextStyle(
                              fontSize: 24.0)),
                          value: 'Yellow',
                          groupValue: _selectedColor,
                          onChanged: (value) {
                            print('Selected Color: $value');
                            setState(() => _selectedColor = value);
                          },
                          activeColor: Colors.yellow,
                        ),
                        SizedBox(height: 12),
                        RadioListTile<String>(
                          title: Text('Green', style: TextStyle(
                              fontSize: 24.0)),
                          value: 'Green',
                          groupValue: _selectedColor,
                          onChanged: (value) {
                            print('Selected Color: $value');
                            setState(() => _selectedColor = value);
                          },
                          activeColor: Colors.green,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _saveChoice(context),
                      child: Text('Save Choice'),
                      style: ElevatedButton.styleFrom(
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}