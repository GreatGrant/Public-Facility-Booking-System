import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facility_boking/models/booking_model.dart';
import 'package:logger/logger.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger logger = Logger();

  // Add a new booking
  Future<void> addBooking(Map<String, dynamic> bookingData) async {
    try {
      await _firestore.collection('bookings').add(bookingData);
    } catch (e) {
      throw Exception('Error adding booking: $e');
    }
  }

  // Get bookings for a specific user
  Future<List<Map<String, dynamic>>> getBookingsByUserId(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .orderBy('bookedAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception('Error fetching bookings: $e');
    }
  }

  Future<int> fetchTotalBooking() async {
    try {
      logger.i('Fetching total bookings count...');
      final snapshot = await _firestore.collection('bookings').get();
      logger.i('Total bookings count: ${snapshot.size}');
      return snapshot.size;
    } catch (e) {
      logger.e('Error fetching total facilities count: $e', error: e);
      throw Exception('Failed to fetch total facilities: $e');
    }
  }

  Future<List<BookingModel>> fetchAllBookings() async {
    try {
      logger.i('Fetching all bookings...');
      final snapshot = await _firestore.collection('bookings').get();
      logger.i('Fetched ${snapshot.size} bookings.');
      return snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      logger.e('Error fetching all bookings: $e', error: e);
      throw Exception('Failed to fetch all bookings: $e');
    }
  }

  // Fetch bookings for today
  Future<List<Map<String, dynamic>>> fetchBookingsForToday() async {
    try {
      logger.i('Fetching bookings for today...');
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      QuerySnapshot snapshot = await _firestore
          .collection('bookings')
          .where('bookedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('bookedAt', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get();

      logger.i('Fetched ${snapshot.docs.length} bookings for today.');
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      logger.e('Error fetching bookings for today: $e', error: e);
      throw Exception('Failed to fetch today\'s bookings: $e');
    }
  }

}
