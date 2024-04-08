import 'package:final_year_project/Screens/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/user.dart';
import 'Authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    //print(user);

    //return either home or authenticate widget
    if (user == null){
      return Authenticate();
    } else {
      return Home();
    }
  }
}
