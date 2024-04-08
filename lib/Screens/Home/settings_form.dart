import 'package:flutter/material.dart';
import '../../Shared/constants.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];
  // Form values
  String? _currentName;
  String? _currentSugars;
  int? _currentStrength;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Text(
            'Update your brew settings.',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 20),
          TextFormField(
            decoration: textInputDecoration,
            validator: (val) => val?.isEmpty ?? true ? 'Please enter a name' : null,
            onChanged: (val) => setState(() => _currentName = val!),
          ),
          SizedBox(height: 20.0),

          //dropdown
          DropdownButtonFormField<String>(
            items: sugars.map((sugar) {
              return DropdownMenuItem(
                value: sugar,
                child: Text("$sugar sugars"),
              );
            }).toList(),
            onChanged: (val) => setState(() => _currentSugars = val!),
          ),

          //slider
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink[400], // Background color
            ),
            child: Text(
              'Update',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              print(_currentName);
              print(_currentSugars);
              print(_currentStrength);
            },
          ),
        ],
      ),
    );
  }
}
