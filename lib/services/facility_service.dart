import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/facility_model.dart';

class FacilityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'facilities';
  final Logger logger = Logger();


  /// Stream available dates from all facilities
  Stream<List<DateTime>> streamAvailableDates() {
    try {
      logger.i('Streaming available dates from all facilities...');
      return _firestore
          .collection(collectionPath)
          .snapshots()
          .map((snapshot) {
        List<DateTime> availableDates = [];

        for (var doc in snapshot.docs) {
          // Get the availability dates from each facility document
          var facilityData = doc.data();
          if (facilityData.containsKey('availabilityDates')) {
            var dates = List<String>.from(facilityData['availabilityDates']);

            // Convert the string dates to DateTime objects and add to the list
            availableDates.addAll(
              dates.map((date) => DateTime.parse(date)).toList(),
            );
          }
        }

        // Remove duplicates (if any) and return the list of unique available dates
        return availableDates.toSet().toList()..sort();
      });
    } catch (e) {
      logger.e('Error streaming available dates: $e', error: e);
      throw Exception('Failed to stream available dates: $e');
    }
  }

  /// Fetch all facilities
  Future<List<FacilityModel>> fetchAllFacilities() async {
    try {
      logger.i('Fetching all facilities...');
      final snapshot = await _firestore.collection(collectionPath).get();
      logger.i('Fetched ${snapshot.size} facilities.');
      return snapshot.docs
          .map((doc) => FacilityModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      logger.e('Error fetching all facilities: $e', error: e);
      throw Exception('Failed to fetch all facilities: $e');
    }
  }

  /// Fetch facilities by category
  Future<List<FacilityModel>> fetchFacilitiesByCategory(String category) async {
    try {
      logger.i('Fetching facilities for category: $category...');
      final snapshot = await _firestore
          .collection(collectionPath)
          .where('category', isEqualTo: category)
          .get();
      logger.i('Fetched ${snapshot.size} facilities for category: $category.');
      return snapshot.docs
          .map((doc) => FacilityModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      logger.e('Error fetching facilities by category: $e', error: e);
      throw Exception('Failed to fetch facilities by category: $e');
    }
  }

  /// Fetch featured facilities
  Future<List<FacilityModel>> fetchFeaturedFacilities() async {
    try {
      logger.i('Fetching featured facilities...');
      final snapshot = await _firestore
          .collection(collectionPath)
          .where('isFeatured', isEqualTo: true)
          .get();
      logger.i('Fetched ${snapshot.size} featured facilities.');
      return snapshot.docs
          .map((doc) => FacilityModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      logger.e('Error fetching featured facilities: $e', error: e);
      throw Exception('Failed to fetch featured facilities: $e');
    }
  }

  /// Fetch the total count of facilities
  Future<int> fetchTotalFacilities() async {
    try {
      logger.i('Fetching total facilities count...');
      final snapshot = await _firestore.collection(collectionPath).get();
      logger.i('Total facilities count: ${snapshot.size}');
      return snapshot.size;
    } catch (e) {
      logger.e('Error fetching total facilities count: $e', error: e);
      throw Exception('Failed to fetch total facilities: $e');
    }
  }

  /// Create a new facility
  Future<void> createFacility(FacilityModel facility) async {
    try {
      logger.i('Creating a new facility: ${facility.name}...');
      await _firestore.collection(collectionPath).add(facility.toFirestore());
      logger.i('Facility created successfully.');
    } catch (e) {
      logger.e('Error creating facility: $e', error: e);
      throw Exception('Failed to create facility: $e');
    }
  }

  /// Update a facility
  Future<void> updateFacility(String id, FacilityModel facility) async {
    try {
      logger.i('Updating facility with ID: $id...');
      await _firestore.collection(collectionPath).doc(id).update(facility.toFirestore());
      logger.i('Facility updated successfully.');
    } catch (e) {
      logger.e('Error updating facility: $e', error: e);
      throw Exception('Failed to update facility: $e');
    }
  }

  /// Delete a facility
  Future<void> deleteFacility(String id) async {
    try {
      logger.i('Deleting facility with ID: $id...');
      await _firestore.collection(collectionPath).doc(id).delete();
      logger.i('Facility deleted successfully.');
    } catch (e) {
      logger.e('Error deleting facility: $e', error: e);
      throw Exception('Failed to delete facility: $e');
    }
  }
}
