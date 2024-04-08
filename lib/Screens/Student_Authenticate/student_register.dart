import 'package:flutter/material.dart';
import '../../Services/student_auth.dart';
import '../../Services/teacher_auth.dart';
import '../../Shared/constants.dart';
import '../../Shared/loading.dart';


class StudentRegister extends StatefulWidget {
  final Function toggleView;
  const StudentRegister({super.key, required this.toggleView});
  @override
  State<StudentRegister> createState() => _RegisterState();
}

class _RegisterState extends State<StudentRegister> {
  //text field state
  final StudentAuthService _auth = StudentAuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String email = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return loading? Loading(): Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Student registration'),
        actions: <Widget>[
          ElevatedButton.icon(
              icon: Icon(Icons.person),
              label: Text('Sign In'),
              onPressed: () {
                widget.toggleView();
              }
          )
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
              TextButton(
                child: Text('Register'),
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Colors.pink[400]),
                    textStyle: MaterialStateProperty.all(
                        TextStyle(color: Colors.white))),
                onPressed: () async {
                  if (_formKey.currentState!.validate()){
                    setState(() => loading = true);
                    dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                    if(result == null){
                      setState(() {
                        error = 'please supply a valid email';
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
