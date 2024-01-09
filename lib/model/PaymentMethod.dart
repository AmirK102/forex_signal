import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentMethod {
  final String phone;
  final String type;
  final DateTime createdAt;
  final String status;
  final String id;

  PaymentMethod({
    required this.phone,
    required this.id,
    required this.type,
    required this.createdAt,
    required this.status,
  });

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      phone: map['phone'],
      id: map['id'],
      type: map['type'],
      createdAt: (map['create_at'] as Timestamp).toDate(),
      status: map['status'],
    );
  }
}