import 'package:final_year_project/Screens/Home/home.dart';
import 'package:flutter/material.dart';

import 'Authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //return either home or authenticate widget
    return Authenticate();
  }
}
