import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/facility_model.dart';

class FacilityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String collectionPath = 'facilities';

  /// Fetch all facilities
  Future<List<FacilityModel>> fetchAllFacilities() async {
    try {
      final snapshot = await _firestore.collection(collectionPath).get();
      return snapshot.docs
          .map((doc) => FacilityModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch all facilities: $e');
    }
  }

  /// Fetch facilities by category
  Future<List<FacilityModel>> fetchFacilitiesByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection(collectionPath)
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs
          .map((doc) => FacilityModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch facilities by category: $e');
    }
  }

  /// Fetch featured facilities
  Future<List<FacilityModel>> fetchFeaturedFacilities() async {
    try {
      final snapshot = await _firestore
          .collection(collectionPath)
          .where('isFeatured', isEqualTo: true)
          .get();
      return snapshot.docs
          .map((doc) => FacilityModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch featured facilities: $e');
    }
  }

  /// Fetch the total count of facilities
  Future<int> fetchTotalFacilities() async {
    try {
      final snapshot = await _firestore.collection(collectionPath).get();
      return snapshot.size; // Firestore's size property gives the document count
    } catch (e) {
      throw Exception('Failed to fetch total facilities: $e');
    }
  }
  // Create a new facility
  Future<void> createFacility(FacilityModel facility) async {
    try {
      await _firestore
          .collection(collectionPath)
          .add(facility.toFirestore());
    } catch (e) {
      throw Exception('Failed to create facility: $e');
    }
  }

  // Update a facility
  Future<void> updateFacility(String id, FacilityModel facility) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(id)
          .update(facility.toFirestore());
    } catch (e) {
      throw Exception('Failed to update facility: $e');
    }
  }

  // Delete a facility
  Future<void> deleteFacility(String id) async {
    try {
      await _firestore.collection(collectionPath).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete facility: $e');
    }
  }
}
