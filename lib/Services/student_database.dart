import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/brew.dart';
import '../Models/student_user.dart';
import '../Models/teacher_user.dart';

class StudentDatabaseService {
  final String uid;
  StudentDatabaseService({required this.uid});

  final CollectionReference brewCollection =
  FirebaseFirestore.instance.collection('Student');

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

  Future<void> joinClass(String classCode) async {
    try {
      // Get the class document with the provided class code
      final QuerySnapshot classSnapshot = await FirebaseFirestore.instance
          .collection('classes')
          .where('classCode', isEqualTo: classCode)
          .limit(1)
          .get();

      if (classSnapshot.docs.isNotEmpty) {
        // Class with the entered code exists
        // Get the class ID
        String classId = classSnapshot.docs.first.id;

        // Retrieve student's name from Firestore using UID
        DocumentSnapshot studentSnapshot = await brewCollection.doc(uid).get();
        String studentName = studentSnapshot.get('name');

        // Update student's data to include the class they joined
        await brewCollection.doc(uid).update({
          'classId': classId,
        });

        // Store the student's name within the class document
        await FirebaseFirestore.instance
            .collection('classes')
            .doc(classId)
            .collection('students')
            .doc(uid)
            .set({
          'name': studentName,
        });
      } else {
        // Class with the entered code does not exist
        throw Exception('Class with code $classCode does not exist!');
      }
    } catch (error) {
      print('Error joining class: $error');
      throw error;
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
  StudentUserData userDataFromSnapshot(DocumentSnapshot snapshot) {
    return StudentUserData(
      uid: uid,
      name: snapshot.get('name') ?? '',
    );
  }

  // Get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  // Get user document stream
  Stream<StudentUserData> get userData {
    return brewCollection.doc(uid).snapshots().map(userDataFromSnapshot);
  }
}
