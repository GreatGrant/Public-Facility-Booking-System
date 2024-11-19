class FacilityModel {
  final String id; // Firestore document ID
  final String name;
  final String imageUrl;
  final String category;
  final String description; // New field for facility description
  final double rating;
  final bool isFeatured;
  final List<DateTime> availabilityDates; // New field for availability

  FacilityModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.description,
    required this.rating,
    required this.isFeatured,
    required this.availabilityDates,
  });

  factory FacilityModel.fromFirestore(Map<String, dynamic> data, String id) {
    return FacilityModel(
      id: id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '', // Populate description
      rating: (data['rating'] ?? 0.0).toDouble(),
      isFeatured: data['isFeatured'] ?? false,
      availabilityDates: (data['availabilityDates'] as List<dynamic>?)
          ?.map((date) => DateTime.parse(date.toString()))
          .toList() ??
          [], // Convert availabilityDates from Firestore to DateTime
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'category': category,
      'description': description, // Add description to Firestore
      'rating': rating,
      'isFeatured': isFeatured,
      'availabilityDates': availabilityDates.map((date) => date.toIso8601String()).toList(), // Convert DateTime to Firestore-compatible format
    };
  }
}
