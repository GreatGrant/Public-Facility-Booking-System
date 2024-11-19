class UserModel {
  final String id; // Firestore document ID
  final String name;
  final String email;
  final String phoneNumber;
  final String profileImage;
  final List<String> recentBookings;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profileImage,
    required this.recentBookings,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      profileImage: data['profileImage'] ?? '',
      recentBookings: List<String>.from(data['recentBookings'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'recentBookings': recentBookings,
    };
  }
}
