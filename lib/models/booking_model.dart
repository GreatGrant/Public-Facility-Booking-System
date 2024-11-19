class BookingModel {
  final String id; // Firestore document ID
  final String userId;
  final String facilityId;
  final DateTime startDate;
  final DateTime endDate;
  final String status; // e.g., "Pending", "Approved", "Completed"

  BookingModel({
    required this.id,
    required this.userId,
    required this.facilityId,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory BookingModel.fromFirestore(Map<String, dynamic> data, String id) {
    return BookingModel(
      id: id,
      userId: data['userId'] ?? '',
      facilityId: data['facilityId'] ?? '',
      startDate: DateTime.parse(data['startDate'] ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(data['endDate'] ?? DateTime.now().toIso8601String()),
      status: data['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'facilityId': facilityId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
    };
  }
}
