import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/student_user.dart';
import '../../Models/teacher_user.dart';
import '../../Services/student_database.dart';
import '../../Shared/constants.dart';
import '../../Shared/loading.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  State<SettingsForm> createState() => Student_SettingsFormState();
}

class Student_SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];
  // Form values
  String? _currentName;
  String? _currentSugars;
  int? _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<StudentMyUser?>(context);

    return StreamBuilder<StudentUserData>(
      stream: StudentDatabaseService(uid: user?.uid ?? '').userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          StudentUserData? userData = snapshot.data;
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
                  initialValue: userData?.name,
                  decoration: textInputDecoration,
                  validator: (val) =>
                  val?.isEmpty ?? true ? 'Please enter a name' : null,
                  onChanged: (val) => setState(() => _currentName = val!),
                ),
                SizedBox(height: 20.0),

                // Dropdown
                DropdownButtonFormField<String>(
                  decoration: textInputDecoration,
                  value: _currentSugars ?? userData?.sugars ?? '0',
                  items: sugars.map((sugar) {
                    return DropdownMenuItem(
                      value: sugar,
                      child: Text("$sugar sugars"),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _currentSugars = val!),
                ),
                Slider(
                  value:
                  (_currentStrength ?? userData?.strength ?? 100).toDouble(),
                  activeColor: Colors.brown[_currentStrength ?? 100],
                  inactiveColor: Colors.brown[_currentStrength ?? 100],
                  min: 100,
                  max: 900,
                  divisions: 8,
                  onChanged: (val) =>
                      setState(() => _currentStrength = val.round()),
                ),

                // Slider
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[400], // Background color
                  ),
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      await StudentDatabaseService(uid: user?.uid ?? '').updateUserData(
                        _currentSugars ?? userData?.sugars ?? '',
                        _currentName ?? userData?.name ?? '',
                        _currentStrength ?? userData?.strength ?? 100,
                      );
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          );
        } else {
          // Handle the case where snapshot has no data
          return Loading(); // Or any other appropriate widget
        }
      },
    );
  }
}
