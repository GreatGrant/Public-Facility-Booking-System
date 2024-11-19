class FacilityModel {
  final String id; // Firestore document ID
  final String name;
  final String imageUrl;
  final String category;
  final double rating;
  final bool isFeatured;

  FacilityModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.isFeatured,
  });

  factory FacilityModel.fromFirestore(Map<String, dynamic> data, String id) {
    return FacilityModel(
      id: id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      isFeatured: data['isFeatured'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'category': category,
      'rating': rating,
      'isFeatured': isFeatured,
    };
  }
}
