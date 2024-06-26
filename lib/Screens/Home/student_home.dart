import 'package:flutter/material.dart';
import 'package:final_year_project/Services/student_auth.dart';
import 'package:final_year_project/Models/brew.dart';
import 'package:final_year_project/Services/student_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../Student pages/chat.dart';
import '../Student pages/example_exit_ticket.dart';
import '../Student pages/example_interactive.dart';
import '../Student pages/example_quiz.dart';
import '../Student pages/example_unplugged.dart';
import '../Student pages/revison.dart';
import '../Student pages/traffic_lights.dart';
import '../../main.dart';

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
                  _navigateToInteractive(assignment);
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
                  _navigateExitTicket(assignment);
                },
                child: Text('Hard'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  // Handle challenge difficulty
                  Navigator.pop(context); // Close the dialog
                  print('Challenge difficulty selected');
                  _navigateUnplugged(assignment);
                },
                child: Text('Challenge'),
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

        ),
      ),
    );
  }

  void _navigateToInteractive(dynamic assignment) {
    // Navigate to the new widget for low difficulty
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExampleInteractive(

        ),
      ),
    );
  }

  void _navigateExitTicket(dynamic assignment) {
    // Navigate to the new widget for low difficulty
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExampleExitTicket(

        ),
      ),
    );
  }

  void _navigateUnplugged(dynamic assignment) {
    // Navigate to the new widget for low difficulty
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExampleUnplugged(

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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[200],
      appBar: AppBar(
        title: Text(
          'Student Home Page',
          style: TextStyle(
            fontFamily: 'Jersey 10', // Use your font family name here
            fontSize: 30,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Sell()),  // Navigate to Sell page
            );
          },
          child: Image.asset('assets/logo.png', height: 40, width: 40),  // Replace with your logo path
        ),
        backgroundColor: Colors.brown[600],
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person, color: Colors.white), // Icon for Logout
            label: Text('Logout', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
          TextButton.icon(
            icon: Icon(Icons.book, color: Colors.white), // Icon for Revision
            label: Text(
              'Revision',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            onPressed: () {
              // Navigate to the RevisionPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RevisionPage(),
                ),
              );
            },
          ),
          TextButton.icon(
            icon: Icon(Icons.chat, color: Colors.white), // Icon for Chat
            label: Text(
              'Chat',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(chatId: 'class chat'), // Replace with actual chatId
                ),
              );
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
                      color: Colors.green[90],
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
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.brown[400]), // Change background color to brown
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: classes.length,
                itemBuilder: (context, index) {
                  String className = classes[index];
                  String classId = assignments.keys.elementAt(index); // Get document ID (classId) from assignments map
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
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.brown[400]), // Change background color to brown
                                    ),
                                  ),
                                ],
                              ),
                              Divider(), // Divider between assignments
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end, // Align buttons to the end (right side) of the row
                        children: [
                          ElevatedButton(
                            onPressed: () => _leaveClass(context, className),
                            child: Text('Leave Class'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.brown[400]), // Change background color to brown
                            ),
                          ),
                          SizedBox(width: 8), // Adding a small space between the buttons
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to TrafficLightsSelection widget for this class
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TrafficLightsSelection(classCode: 'j9'), // Use document ID
                                ),
                              );
                            },
                            child: Text('Traffic Lights'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.brown[400]), // Change background color to brown
                            ),
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

    );
  }
}