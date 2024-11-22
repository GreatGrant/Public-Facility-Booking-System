class FacilityModel {
  final String id; // Firestore document ID
  final String name;
  final String imageUrl;
  final String category;
  final String description; // Field for facility description
  final double rating;
  final bool isFeatured;
  final List<DateTime> availabilityDates; // Field for availability
  final String location; // Location as a string (address)
  final double price; // Added price field

  FacilityModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.description,
    required this.rating,
    required this.isFeatured,
    required this.availabilityDates,
    required this.location, // String address for location
    required this.price, // Added price to the constructor
  });

  factory FacilityModel.fromFirestore(Map<String, dynamic> data, String id) {
    return FacilityModel(
      id: id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      isFeatured: data['isFeatured'] ?? false,
      availabilityDates: (data['availabilityDates'] as List<dynamic>?)
          ?.map((date) => DateTime.parse(date.toString()))
          .toList() ??
          [],
      location: data['location'] ?? '', // Directly using location as a string
      price: (data['price'] ?? 0.0).toDouble(), // Parse price from Firestore
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
      'availabilityDates': availabilityDates.map((date) => date.toIso8601String()).toList(),
      'location': location, // Storing location directly as a string
      'price': price, // Store price in Firestore
    };
  }
}
