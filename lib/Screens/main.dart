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
      home: Scaffold(
        appBar: AppBar(
          leading: Image.asset('assets/logo.png'),
          centerTitle: true,
          title: const Text("Byte Assess"),
          actions: [
            IconButton(
              icon: Icon(Icons.settings, size: 30.0),
              onPressed: () {
                // Add functionality for settings button
              },
            ),
          ],
        ),
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
