import 'package:flutter/material.dart';

import '../../Services/student_auth.dart';
import '../../Services/teacher_auth.dart';
import '../../Shared/constants.dart';
import '../../Shared/loading.dart';
import '../Home/role_selection.dart';

class TeacherSignIn extends StatefulWidget {
  final Function toggleView;
  const TeacherSignIn({super.key, required this.toggleView});
  @override
  State<TeacherSignIn> createState() => _SignInState();
}

class _SignInState extends State<TeacherSignIn> {
  final TeacherAuthService _auth = TeacherAuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading? Loading(): Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        elevation: 0.0,
        title: Text('Teacher sign in'),
        actions: <Widget>[
          ElevatedButton.icon(
              icon: Icon(Icons.person),
              label: Text('Register'),
              onPressed: () {
                widget.toggleView();
              }
          ),
      //some space between the buttons
        ],
      ),

      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val) => val!.isEmpty ? "Enter an email" : null,
                  onChanged: (val) {
                  setState(() => email = val);
                }
              ),
              SizedBox(height: 20.0),
              TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Password'),
                  obscureText: true,
                  validator: (val) => val!.length < 6 ? "Enter a password 6+ chars long" : null,
                  onChanged: (val) {
                  setState(() => password = val);
                }
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                child: Text('Sign in'),
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Colors.green),
                    textStyle: MaterialStateProperty.all(
                        TextStyle(color: Colors.white))),
                onPressed: () async {
                  if (_formKey.currentState!.validate()){
                    setState(() => loading = true);
                    dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                    if(result == null){
                      setState(() {
                        error = 'Could not sign in with those credentials';
                        loading = false;
                      });
                    }
                  }
                },
              ),
              SizedBox(height: 12),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],

          ),
        ),
      ),
    );
  }
}
