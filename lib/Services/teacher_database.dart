import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/brew.dart';
import '../Models/teacher_user.dart';

class TeacherDatabaseService {
  final String uid;
  TeacherDatabaseService({required this.uid});

  // Collection reference
  final CollectionReference brewCollection =
  FirebaseFirestore.instance.collection('Teachers');

  Future<void> updateUserData(String name, String email) async {
    try {
      await brewCollection.doc(uid).set({
        'name': name,
        'email': email,
      });
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  // Brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Brew(
        name: doc.get('name') ?? '',
      );
    }).toList();
  }

  // User data from snapshot
  TeacherUserData userDataFromSnapshot(DocumentSnapshot snapshot) {
    return TeacherUserData(
      uid: uid,
      name: snapshot.get('name') ?? '',
    );
  }

  // Get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  // Get user document stream
  Stream<TeacherUserData> get userData {
    return brewCollection.doc(uid).snapshots().map(userDataFromSnapshot);
  }
}
