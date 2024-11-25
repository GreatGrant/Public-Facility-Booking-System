import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../models/booking_model.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _userData;
  final UserService _userService = UserService();
  final Logger logger = Logger();

  Map<String, dynamic>? get userData => _userData;

  List<BookingModel> get recentBookings {
    if (_userData != null && _userData!['recentBookings'] != null) {
      return List<BookingModel>.from(
        _userData!['recentBookings'].map((data) =>
            BookingModel.fromFirestore(data as Map<String, dynamic>, data['id'])),
      );
    }
    return [];
  }

  Future<void> fetchUserData() async {
    try {
      logger.i('Fetching user data...');
      _userData = await _userService.getUserData();
      logger.i('User data fetched successfully: $_userData');
      notifyListeners();
    } catch (e) {
      logger.e('Error fetching user data: $e');
    }
  }

  Future<void> addBooking(BookingModel booking) async {
    try {
      logger.i('Adding new booking: ${booking.toFirestore()}');

      // Ensure recentBookings exists and is a list
      if (_userData != null) {
        _userData!['recentBookings'] ??= [];
        if (_userData!['recentBookings'] is! List) {
          logger.w('recentBookings is not a valid list.');
          throw Exception("recentBookings is not a valid list.");
        }

        // Log current state of recentBookings
        logger.d('Current recentBookings: ${_userData!['recentBookings']}');

        // Add the new booking locally
        (_userData!['recentBookings'] as List).add(booking.toFirestore());
        notifyListeners();

        // Log updated state of recentBookings
        logger.d('Updated recentBookings: ${_userData!['recentBookings']}');

        // Update Firestore
        await _userService.updateUserData(_userData!);

        logger.i('Booking added successfully.');

        // Notify listeners
        notifyListeners();
      } else {
        logger.w('User data is not initialized.');
        throw Exception("User data is not initialized.");
      }
    } catch (e) {
      logger.e('Error updating bookings: $e');
    }
  }
}
