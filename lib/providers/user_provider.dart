import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../models/booking_model.dart';
import '../services/booking_service.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _userData;
  List<BookingModel> _recentBookings = [];
  List<BookingModel> _bookings = [];

  int _totalUsers = 0;
  int get totalUsers => _totalUsers;


  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> get users => _users;

  List<BookingModel> get bookings => _bookings;

  final BookingService _bookingService = BookingService();
  final UserService _userService = UserService();

  final Logger logger = Logger();

  // Getter for user data
  Map<String, dynamic>? get userData => _userData;

  // Getter for recent bookings
  List<BookingModel> get recentBookings => _recentBookings;

  /// Fetches user data from the database
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

  /// Stream that listens for real-time updates on recent bookings
  Stream<List<BookingModel>> streamUserBookings(String userId) {
    try {
      logger.i('Listening for real-time updates of bookings for user: $userId...');
      return FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .orderBy('bookedAt', descending: true)
          .snapshots()
          .map((querySnapshot) {
        List<BookingModel> bookings = [];
        for (var doc in querySnapshot.docs) {
          // Log the raw document data before converting it to BookingModel
          logger.i('Document data: ${doc.data()}');

          bookings.add(BookingModel.fromFirestore(doc.data()));
        }
        logger.i('Real-time bookings update for user $userId: ${bookings.length} booking(s)');
        return bookings;
      });
    } catch (e) {
      logger.e('Error streaming bookings for user $userId: $e');
      return const Stream.empty();
    }
  }


  /// Adds a new booking for the user
  Future<void> addBooking(BookingModel booking) async {
    try {
      logger.i('Adding new booking: ${booking.toFirestore()}');
      await _bookingService.addBooking(booking);
      logger.i('Booking added successfully.');

      // Optionally, update bookings list
      // await fetchBookings(booking.userId);
    } catch (e) {
      logger.e('Error adding booking: $e');
    }
  }

  Future<void> fetchAllUsers() async {
    try {
      logger.i('Fetching all users...');
      _users = await _userService.fetchAllUsers();
      logger.i('All users fetched successfully');
      notifyListeners();
    } catch (e) {
      logger.e('Error fetching all users: $e');
    }
  }

  // Update user data for a specific user
  Future<void> updateUserData(String userId, Map<String, dynamic> userData) async {
    try {
      logger.i('Updating user data for user ID: $userId');
      await _userService.updateUserData(userId, userData);
      logger.i('User data updated successfully for user ID: $userId');
      // Optionally, refresh the users list
      await fetchAllUsers();
    } catch (e) {
      logger.e('Error updating user data: $e');
    }
  }

  // Delete a user
  Future<void> deleteUser(String userId) async {
    try {
      logger.i('Deleting user with ID: $userId');
      await _userService.deleteUser(userId);
      logger.i('User deleted successfully');
      // Refresh the users list after deletion
      await fetchAllUsers();
    } catch (e) {
      logger.e('Error deleting user: $e');
    }
  }

  Future<void> getTotalUsers() async {
    try {
      logger.i('Getting all users');
      _totalUsers = await _userService.getTotalUsers();
      logger.i('Users gotten successfully');
      // Refresh the users list after deletion
      await fetchAllUsers();
    } catch (e) {
      logger.e('Error getting users: $e');
    }
  }

}
