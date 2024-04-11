import 'package:flutter/material.dart';
import 'package:final_year_project/Services/student_auth.dart';
import 'package:final_year_project/Models/brew.dart';
import 'package:final_year_project/Services/student_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../Student pages/example_quiz.dart';

class StudentHome extends StatefulWidget {
  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  final StudentAuthService _auth = StudentAuthService();
  final TextEditingController _classCodeController = TextEditingController();
  List<String> classes = [];
  Map<String, List<dynamic>> assignments = {};

  @override
  void initState() {
    super.initState();
    _fetchStudentData(); // Fetch data when the page loads
  }

  Future<void> _fetchStudentData() async {
    String? studentName = (await _auth.getCurrentUserInfo())['studentName'];

    if (studentName != null) {
      final QuerySnapshot classSnapshot = await FirebaseFirestore.instance
          .collection('classes')
          .where('students', arrayContains: studentName)
          .get();

      for (QueryDocumentSnapshot classDoc in classSnapshot.docs) {
        String className = classDoc['className'];
        String classId = classDoc.id;
        classes.add(className);

        final QuerySnapshot assignmentSnapshot = await FirebaseFirestore.instance
            .collection('formative_assessments')
            .where(FieldPath.documentId, isEqualTo: classId)
            .get();

        List<dynamic> classAssignments = assignmentSnapshot.docs.map((doc) => doc.data()).toList();
        assignments[className] = classAssignments;
      }
    }

    setState(() {}); // Update UI after fetching data
  }

  Future<void> _joinClass(BuildContext context) async {
    String classCode = _classCodeController.text.trim();
    String? studentName = (await _auth.getCurrentUserInfo())['studentName'];
    String? userId = _auth.getCurrentUser()?.uid; // Get current user ID

    print('Current User ID: $userId'); // Print current user ID

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

        // Check if the class is already in the classes list
        if (classes.contains(className)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You are already in class $className!')),
          );
          return; // Exit the method if the class is already in the list
        }

        // Update the class document to add the student's name
        await FirebaseFirestore.instance.collection('classes').doc(classId).update({
          'students': FieldValue.arrayUnion([studentName]),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Joined $className successfully!')),
        );
        _fetchStudentData(); // Fetch updated data after joining class
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

  void _attemptAssignment(dynamic assignment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Difficulty Level'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SimpleDialogOption(
                onPressed: () {
                  // Handle easy difficulty
                  Navigator.pop(context); // Close the dialog
                  print('Easy difficulty selected');
                },
                child: Text('Easy'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  // Handle medium difficulty
                  Navigator.pop(context); // Close the dialog
                  print('Medium difficulty selected');
                  _navigateToQuiz(assignment); // Navigate to the quiz
                },
                child: Text('Medium'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  // Handle hard difficulty
                  Navigator.pop(context); // Close the dialog
                  print('Hard difficulty selected');
                },
                child: Text('Hard'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToQuiz(dynamic assignment) {
    // Navigate to the new widget for medium difficulty
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizExample(
          title: assignment['topic'],
          imageUrl: 'https://example.com/image.png', // Provide the URL of the image
          options: ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
        ),
      ),
    );
  }



  void _viewReport(dynamic assignment) {
    // Implement action for viewing report
    print('Viewing report for assignment: ${assignment['topic']} - ${assignment['subtopic']}');
  }

  Future<void> _leaveClass(BuildContext context, String className) async {
    String? studentName = (await _auth.getCurrentUserInfo())['studentName'];

    if (studentName != null) {
      final QuerySnapshot classSnapshot = await FirebaseFirestore.instance
          .collection('classes')
          .where('className', isEqualTo: className)
          .limit(1)
          .get();

      if (classSnapshot.docs.isNotEmpty) {
        // Class with the entered name exists
        String classId = classSnapshot.docs.first.id;

        // Update the class document to remove the student's name
        await FirebaseFirestore.instance.collection('classes').doc(classId).update({
          'students': FieldValue.arrayRemove([studentName]),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Left $className successfully!')),
        );

        // Remove the class from the list
        classes.remove(className);

        setState(() {}); // Update UI to reflect the changes
      } else {
        // Class with the entered name does not exist
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Class $className not found!')),
        );
      }
    }
  }


  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Revision',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    Text(
      'Index 1: Traffic Lights',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: _auth.getCurrentUserInfo(),
              builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return Text('Error fetching user data');
                }
                String studentName = snapshot.data?['studentName'] ?? 'Unknown';
                return Row(
                  children: [
                    Text(
                      'Welcome, ',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$studentName ',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.waving_hand_outlined,
                      color: Colors.purple,
                      size: 20.0,
                      semanticLabel: 'Welcome',
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 20),
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
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: classes.length,
                itemBuilder: (context, index) {
                  String className = classes[index];
                  List<dynamic> classAssignments = assignments[className] ?? [];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        className,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: classAssignments.length,
                        itemBuilder: (context, index) {
                          dynamic assignment = classAssignments[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(assignment['topic']),
                                subtitle: Text(assignment['subtopic']),
                              ),
                              ButtonBar(
                                children: [
                                  ElevatedButton(
                                    onPressed: () => _attemptAssignment(assignment),
                                    child: Text('Attempt Assignment'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => _viewReport(assignment),
                                    child: Text('View Report'),
                                  ),
                                ],
                              ),
                              Divider(), // Divider between assignments
                            ],
                          );
                        },
                      ),
                      ButtonBar(
                        children: [
                          ElevatedButton(
                            onPressed: () => _leaveClass(context, className),
                            child: Text('Leave Class'),
                          ),
                        ],
                      ),
                      Divider(), // Divider between classes
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Revision',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.traffic),
            label: 'Traffic Lights',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}
