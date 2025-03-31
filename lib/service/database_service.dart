// database_service.dart


import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // Firestore reference
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // Save user data to Firestore
  Future<void> saveUserData(String uid, Map<String, dynamic> userData) async {
    await _firestore.collection('users').doc(uid).set(userData);

  }

  // Get user data from Firestore
  Future<DocumentSnapshot> getUserData(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }


  // Add a post to Firestore
  Future<DocumentReference> addPost(Map<String, dynamic> postData) async {
    return await _firestore.collection('posts').add(postData);
  }

  // Get posts from Firestore
  Stream<QuerySnapshot> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
