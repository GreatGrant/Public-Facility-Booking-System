import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String id; // Unique identifier for the booking
  final String userId; // ID of the user who made the booking
  final String facilityName; // Name of the facility being booked
  final String status; // Booking status (e.g., "Pending", "Approved", "Cancelled")
  final DateTime bookedAt; // Timestamp when the booking was created

  BookingModel({
    required this.id,
    required this.userId,
    required this.facilityName,
    required this.status,
    required this.bookedAt,
  });

  // Convert a Firestore document to a BookingModel instance
  factory BookingModel.fromFirestore(Map<String, dynamic> data) {
    // Handling the bookedAt field to be either a Timestamp or String
    var bookedAtData = data['bookedAt'];
    DateTime bookedAt;
    if (bookedAtData is Timestamp) {
      bookedAt = bookedAtData.toDate();
    } else if (bookedAtData is String) {
      // Try to parse the String as DateTime if it's a String
      bookedAt = DateTime.tryParse(bookedAtData) ?? DateTime.now();
    } else {
      // Default to current time if not a Timestamp or String
      bookedAt = DateTime.now();
    }

    return BookingModel(
      id: data['id'] as String? ?? '', // Default to empty string if 'id' is null
      userId: data['userId'] as String? ?? '', // Default to empty string if 'userId' is null
      facilityName: data['facilityName'] as String? ?? '', // Default to empty string if 'facilityName' is null
      status: data['status'] as String? ?? '', // Default to empty string if 'status' is null
      bookedAt: bookedAt, // Use the parsed or default DateTime
    );
  }

  // Convert a BookingModel instance to a Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'facilityName': facilityName,
      'status': status,
      'bookedAt': bookedAt,
    };
  }
}
