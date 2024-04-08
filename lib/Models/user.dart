class MyUser {
  final String? uid;

  MyUser({this.uid});
}

class UserData {
  final String uid;
  final String name;
  final String sugars;
  final int strength;

  UserData({required this.uid, required this.name, required this.sugars, required this.strength });
}