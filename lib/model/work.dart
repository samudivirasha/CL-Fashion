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

  WorkModel({
    this.id,
    required this.name,
    required this.orderDate,
    required this.endDate,
    required this.status,
    required this.user,
    required this.assingedTo,
    required this.description,
    required this.priority,
  });
  factory WorkModel.fromJson(Map<String, dynamic> json) {
    return WorkModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      orderDate: DateTime.parse(json['orderDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      status: json['status'] as String,
      user: json['user'] as UserModel,
      assingedTo: json['assingedTo'] as UserModel,
      description: json['description'] as String,
      priority: json['priority'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'orderDate': orderDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
      'user': user.toJson(),
      'assingedTo': assingedTo.toJson(),
      'description': description,
      'priority': priority,
    };
  }
}
