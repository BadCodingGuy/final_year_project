import 'package:final_year_project/Screens/student_wrapper.dart';
import 'package:final_year_project/Screens/teacher_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/teacher_user.dart';
import '../Services/student_auth.dart';
import '../Services/teacher_auth.dart';
import 'Home/role_selection.dart';
import 'Home/student_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDGiidEEu9r056dZJhXNeFVQJwmKv4sRqU",
        appId: "1:941947686765:web:966510ae75ba15c1381464",
        messagingSenderId: "941947686765",
        projectId: "final-year-project-8a666",
      ),
    );
  }
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Byte Access',
      home: Sell(),
    );
  }
}
class CallT extends StatelessWidget {
  const CallT({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      catchError: (_, __) => null,
      value: TeacherAuthService().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TeacherWrapper(),
      ),
    );
  }
}

class CallS extends StatelessWidget {
  const CallS({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      catchError: (_, __) => null,
      value: StudentAuthService().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StudentWrapper(),
      ),
    );
  }
}

class Sell extends StatefulWidget {
  @override
  _RoleSelectorState createState() => _RoleSelectorState();
}

class _RoleSelectorState extends State<Sell> {
  String selectedUserRole = '';

  void recordUserChoice(String role) {
    setState(() {
      selectedUserRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('Welcome to Byte Access - Please select your role'),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                recordUserChoice('Teacher');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CallT()),
                );
              },
              child: Text('Teacher'),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                recordUserChoice('Student');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CallS()),
                );
              },
              child: Text('Student'),
            ),
          ),
        ],
      ),
    );
  }
}
