import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String type;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.address,
      required this.type});
  factory UserModel.fromJson(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      type: json['type'] as String,
    );
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final json = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'type': type
    };
  }
}
