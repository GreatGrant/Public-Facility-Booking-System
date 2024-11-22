import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _userData;
  final UserService _userService = UserService();

  Map<String, dynamic>? get userData => _userData;

  List<BookingModel> get recentBookings {
    if (_userData != null && _userData!['recentBookings'] != null) {
      return List<BookingModel>.from(_userData!['recentBookings'].map((data) =>
          BookingModel.fromFirestore(data as Map<String, dynamic>, data['id'])));
    }
    return [];
  }

  Future<void> fetchUserData() async {
    try {
      _userData = await _userService.getUserData();
      notifyListeners();
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> addBooking(BookingModel booking) async {
    try {
      _userData!['recentBookings'].add(booking.toFirestore());
      await _userService.updateUserData(_userData!); // Update Firestore or DB
      notifyListeners();
    } catch (e) {
      print('Error updating bookings: $e');
    }
  }
}
