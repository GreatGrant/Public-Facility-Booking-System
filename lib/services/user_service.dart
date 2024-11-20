import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<UserModel?> getUser(String id) async {
    try {
      final doc = await usersCollection.doc(id).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<void> createUser(UserModel user) async {
    try {
      await usersCollection.doc(user.id).set(user.toFirestore());
    } catch (e) {
      print('Error creating user: $e');
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await usersCollection.doc(user.id).update(user.toFirestore());
    } catch (e) {
      print('Error updating user: $e');
    }
  }
}
