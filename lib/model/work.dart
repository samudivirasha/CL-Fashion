import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cl_fashion/model/user_model.dart';

class WorkModel {
  final String? id;
  final String name;
  final DateTime orderDate;
  final DateTime endDate;
  final String status;
  final UserModel user;
  final UserModel assingedTo;
  final String description;
  final String priority;
  final String measurements;

  WorkModel(
      {this.id,
      required this.name,
      required this.orderDate,
      required this.endDate,
      required this.status,
      required this.user,
      required this.assingedTo,
      required this.description,
      required this.priority,
      required this.measurements});

  factory WorkModel.fromDocument(DocumentSnapshot doc) {
    final json = doc.data() as Map<String, dynamic>;

    DateTime parseDate(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      } else if (value is String) {
        return DateTime.parse(value);
      } else {
        throw Exception('Invalid date format');
      }
    }

    return WorkModel(
      id: doc.id,
      name: json['name'] ?? '',
      orderDate: parseDate(json['orderDate']),
      endDate: parseDate(json['endDate']),
      status: json['status'] ?? '',
      user: UserModel.fromJson(json['user'], json['user']['id']),
      assingedTo:
          UserModel.fromJson(json['assingedTo'], json['assingedTo']['id']),
      description: json['description'] ?? '',
      priority: json['priority'] ?? '',
      measurements: json['measurements'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'orderDate': Timestamp.fromDate(orderDate),
      'endDate': Timestamp.fromDate(endDate),
      'status': status,
      'user': user.toJson(),
      'assingedTo': assingedTo.toJson(),
      'description': description,
      'priority': priority,
      'measurements': measurements
    };
  }
}
