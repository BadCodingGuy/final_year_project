import 'package:final_year_project/Screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Byte Assess',
      debugShowCheckedModeBanner: false,
      home: Wrapper(
      ),
    );
  }
}
