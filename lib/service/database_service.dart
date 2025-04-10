// database_service.dart

import 'package:cl_fashion/model/user_model.dart';
import 'package:cl_fashion/model/work.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // Firestore reference
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save user data to Firestore
  Future<void> saveUserData(String uid, UserModel userData) async {
    await _firestore.collection('users').doc(uid).set(userData.toJson());
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();

    if (doc.exists) {
      return UserModel.fromJson(doc.data() as Map<String, dynamic>, uid);
    }
    return null;
  }

  Stream<List<UserModel>> getUsersData() {
    return _firestore.collection('users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => UserModel.fromDocument(doc)).toList());
  }

  // Add a work to Firestore
  Future<DocumentReference> addWork(WorkModel work) async {
    return await _firestore.collection('works').add(work.toJson());
  }

  // Update a work in Firestore
  Future<void> updateWork(WorkModel work) async {
    await _firestore.collection('works').doc(work.id).update(work.toJson());
  }

  // Delete a work from Firestore
  Future<void> deleteWork(String workId) async {
    await _firestore.collection('works').doc(workId).delete();
  }

  // Get work from Firestore
  Stream<List<WorkModel>> getWorks() {
    return _firestore
        .collection('works')
        .orderBy('endDate', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => WorkModel.fromDocument(doc)).toList());
  }
}
