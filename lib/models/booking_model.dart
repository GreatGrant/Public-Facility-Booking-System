import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String id;
  final String userId;
  final String facilityName;
  final String status;
  final DateTime bookedAt;

  BookingModel({
    required this.id,
    required this.userId,
    required this.facilityName,
    required this.status,
    required this.bookedAt,
  });

  // Convert Firestore document to BookingModel
  factory BookingModel.fromFirestore(Map<String, dynamic> data) {
    return BookingModel(
      id: data['id'] ?? '',
      userId: data['userId'] ?? '',
      facilityName: data['facilityName'] ?? '',
      status: data['status'] ?? 'Pending', // Default to 'Pending'
      bookedAt: (data['bookedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Convert BookingModel to Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'facilityName': facilityName,
      'status': status,
      'bookedAt': Timestamp.fromDate(bookedAt),
    };
  }

  // Method to copy the model with updated fields
  BookingModel copyWith({String? status}) {
    return BookingModel(
      id: id,
      userId: userId,
      facilityName: facilityName,
      status: status ?? this.status,
      bookedAt: bookedAt,
    );
  }
}
