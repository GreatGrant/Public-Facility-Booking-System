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
  final bool isBooked; // New field

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
    required this.isBooked, // New isBooked field
  });

  // CopyWith method to create a copy of the model with some updated fields
  FacilityModel copyWith({
    String? name,
    String? imageUrl,
    String? category,
    String? description,
    double? rating,
    bool? isFeatured,
    List<DateTime>? availabilityDates,
    String? location,
    double? price,
    bool? isBooked, // Allow updating isBooked
  }) {
    return FacilityModel(
      id: this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      isFeatured: isFeatured ?? this.isFeatured,
      availabilityDates: availabilityDates ?? this.availabilityDates,
      location: location ?? this.location,
      price: price ?? this.price,
      isBooked: isBooked ?? this.isBooked, // Handle isBooked
    );
  }

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
      isBooked: data['isBooked'] ?? false, // Parse isBooked from Firestore
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
      'availabilityDates':
      availabilityDates.map((date) => date.toIso8601String()).toList(),
      'location': location, // Storing location directly as a string
      'price': price, // Store price in Firestore
      'isBooked': isBooked, // Store isBooked in Firestore
    };
  }
}
