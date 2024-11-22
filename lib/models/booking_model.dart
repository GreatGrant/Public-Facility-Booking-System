class BookingModel {
  final String id; // Firestore document ID
  final String userId;
  final String facilityId;
  final DateTime bookedAt; // Single booking date
  final String status; // e.g., "Pending", "Approved", "Completed"

  BookingModel({
    required this.id,
    required this.userId,
    required this.facilityId,
    required this.bookedAt,
    required this.status,
  });

  factory BookingModel.fromFirestore(Map<String, dynamic> data, String id) {
    return BookingModel(
      id: id,
      userId: data['userId'] ?? '',
      facilityId: data['facilityId'] ?? '',
      bookedAt: DateTime.parse(data['bookedAt'] ?? DateTime.now().toIso8601String()),
      status: data['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'facilityId': facilityId,
      'bookedAt': bookedAt.toIso8601String(),
      'status': status,
    };
  }
}
