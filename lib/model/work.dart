import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cl_fashion/model/user_model.dart';
import 'package:cl_fashion/model/measurements.dart';

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

  // Measurements data
  final Measurements measurements;

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

    // Create measurements from the nested map or individual fields
    Measurements createMeasurements() {
      if (json['measurements'] is Map) {
        return Measurements.fromJson(json['measurements']);
      } else {
        // Backward compatibility for old data format
        return Measurements(
          bodyLength: (json['bodyLength'] ?? 0).toDouble(),
          shoulder: (json['shoulder'] ?? 0).toDouble(),
          sleeveLength: (json['sleeveLength'] ?? 0).toDouble(),
          chest: (json['chest'] ?? 0).toDouble(),
          waist: (json['waist'] ?? 0).toDouble(),
          bottomWidth: (json['bottomWidth'] ?? 0).toDouble(),
        );
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
      measurements: createMeasurements(),
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
      'measurements': measurements.toJson(),
    };
  }
}
