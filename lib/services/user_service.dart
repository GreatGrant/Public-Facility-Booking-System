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
  Future<void> updateUserData(String userId, Map<String, dynamic> userData) async {
    try {
      await _firestore.collection('users').doc(userId).update(userData);
      logger.i('User data successfully updated for user ID: $userId');
    } catch (e) {
      logger.e('Error updating user data: $e');
      rethrow;
    }
  }

  // Delete user from Firestore
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
      logger.i('User successfully deleted for user ID: $userId');
    } catch (e) {
      logger.e('Error deleting user: $e');
      throw e;
    }
  }

  // Fetch all users from Firestore
  Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      List<Map<String, dynamic>> users = snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
      logger.i('All users fetched successfully');
      return users;
    } catch (e) {
      logger.e('Error fetching all users: $e');
      throw e;
    }
  }

  Future<int> getTotalUsers() async {
    try {
      // Fetch the count of users in the 'users' collection
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      int totalUsers = querySnapshot.docs.length;

      logger.i('Total number of users: $totalUsers');
      return totalUsers;
    } catch (e) {
      logger.e('Error fetching total users: $e');
      throw e;
    }
  }
}
