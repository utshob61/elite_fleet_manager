import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String userId;
  final String carId;
  final DateTime startDate;
  final DateTime endDate;
  final double totalPrice;
  final String status; // pending, confirmed, cancelled, completed
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.userId,
    required this.carId,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  factory Booking.fromFirestore(Map<String, dynamic> data, String id) {
    return Booking(
      id: id,
      userId: data['userId'] ?? '',
      carId: data['carId'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      totalPrice: (data['totalPrice'] ?? 0.0).toDouble(),
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'carId': carId,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'totalPrice': totalPrice,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
