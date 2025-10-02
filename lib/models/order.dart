// lib/models/order.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerOrder {
  final String id;
  final String customerName;
  final String customerPhone;
  final String product;
  final String? message;
  final DateTime createdAt;
  final String status; // 'pending', 'confirmed', 'delivered', 'cancelled'

  CustomerOrder({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.product,
    this.message,
    required this.createdAt,
    this.status = 'pending',
  });

  factory CustomerOrder.fromFirestore(Map<String, dynamic> data, String id) {
    return CustomerOrder(
      id: id,
      customerName: data['customerName'] ?? '',
      customerPhone: data['customerPhone'] ?? '',
      product: data['product'] ?? '',
      message: data['message'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: data['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'customerPhone': customerPhone,
      'product': product,
      'message': message,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status,
    };
  }

  CustomerOrder copyWith({
    String? customerName,
    String? customerPhone,
    String? product,
    String? message,
    DateTime? createdAt,
    String? status,
  }) {
    return CustomerOrder(
      id: id,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      product: product ?? this.product,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}
