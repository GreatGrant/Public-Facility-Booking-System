import 'package:cloud_firestore/cloud_firestore.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
}
