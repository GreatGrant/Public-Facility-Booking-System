class UserModel {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String profileImage;
  final List<String> recentBookings;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profileImage,
    required this.recentBookings,
    required this.role, // Initialize role
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      profileImage: data['profileImage'] ?? '',
      recentBookings: List<String>.from(data['recentBookings'] ?? []),
      role: data['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'recentBookings': recentBookings,
      'role': role,
    };
  }
}
