import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/brew.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid = 'd42pfKXBPyXxw7aWxdBaJV8Ax4z1'});

  //collection reference
  final CollectionReference brewCollection = FirebaseFirestore.instance.collection('brews');
  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength, // Corrected field name
    });
  }
  //brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return Brew(
          name:doc.get('name')??'',
          strength:doc.get("strength")?? 0,
          sugars:doc.get("sugars")?? '0',
      );
    }).toList();
  }
  // get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots()
      .map(_brewListFromSnapshot);
  }
}
