class CalendarEventModel {
  final String id; // Firestore document ID
  final String facilityId;
  final DateTime date;
  final bool isAvailable;

  CalendarEventModel({
    required this.id,
    required this.facilityId,
    required this.date,
    required this.isAvailable,
  });

  factory CalendarEventModel.fromFirestore(Map<String, dynamic> data, String id) {
    return CalendarEventModel(
      id: id,
      facilityId: data['facilityId'] ?? '',
      date: DateTime.parse(data['date'] ?? DateTime.now().toIso8601String()),
      isAvailable: data['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'facilityId': facilityId,
      'date': date.toIso8601String(),
      'isAvailable': isAvailable,
    };
  }
}
