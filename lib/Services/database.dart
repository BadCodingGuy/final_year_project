import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/brew.dart';
import '../Models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // Collection reference
  final CollectionReference brewCollection =
  FirebaseFirestore.instance.collection('brews');

  Future<void> updateUserData(String sugars, String name, int strength) async {
    try {
      await brewCollection.doc(uid).set({
        'sugars': sugars,
        'name': name,
        'strength': strength,
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
        strength: doc.get('strength') ?? 0,
        sugars: doc.get('sugars') ?? '0',
      );
    }).toList();
  }

  // User data from snapshot
  UserData userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.get('name') ?? '',
      sugars: snapshot.get('sugars') ?? '0',
      strength: snapshot.get('strength') ?? 0,
    );
  }

  // Get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  // Get user document stream
  Stream<UserData> get userData {
    return brewCollection.doc(uid).snapshots().map(userDataFromSnapshot);
  }
}
