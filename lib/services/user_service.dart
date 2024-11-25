import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Logger logger = Logger();

  // Fetch user data from Firestore
  Future<Map<String, dynamic>> getUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        logger.i('Fetching data for user ID: ${user.uid}');

        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          logger.i('User data retrieved successfully');
          return userDoc.data() as Map<String, dynamic>;
        } else {
          logger.w('User document not found');
          throw Exception('User not found');
        }
      } else {
        logger.w('No user is currently logged in');
        throw Exception('No user is logged in');
      }
    } catch (e) {
      logger.e('Error fetching user data: $e');
      throw e;
    }
  }

  // Update user data in Firestore
  Future<void> updateUserData(Map<String, dynamic> userData) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        logger.w('No user is logged in while trying to update data');
        throw Exception("No user is logged in");
      }

      logger.i('Updating user data for user ID: ${user.uid}');
      logger.d('Data to update: ${userData['recentBookings']}');

      await _firestore.collection('users').doc(user.uid).update({
        'recentBookings': userData['recentBookings'] ?? [],
      });

      logger.i('User data successfully updated in Firestore');
    } catch (e) {
      logger.e('Error updating user data: $e');
      throw e;
    }
  }
}
