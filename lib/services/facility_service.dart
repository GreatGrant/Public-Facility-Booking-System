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

  /// Stream facilities based on a search query for name or location
  Stream<List<FacilityModel>> searchFacilitiesByNameOrLocation(String query) {
    try {
      logger.i('Searching facilities by name or location with query: $query...');
      final collection = _firestore.collection(collectionPath);

      // Query by name
      final nameQuery = collection
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff');

      // Query by location
      final locationQuery = collection
          .where('location', isGreaterThanOrEqualTo: query)
          .where('location', isLessThanOrEqualTo: '$query\uf8ff');

      // Combine both queries
      return nameQuery.snapshots().asyncExpand((nameSnapshot) {
        return locationQuery.snapshots().map((locationSnapshot) {
          final nameDocs = nameSnapshot.docs;
          final locationDocs = locationSnapshot.docs;

          // Combine and deduplicate documents
          final allDocs = [
            ...nameDocs,
            ...locationDocs.where((locDoc) =>
            !nameDocs.any((nameDoc) => nameDoc.id == locDoc.id))
          ];

          return allDocs.map((doc) {
            return FacilityModel.fromFirestore(doc.data(), doc.id);
          }).toList();
        });
      });
    } catch (e) {
      logger.e('Error searching facilities by name or location: $e', error: e);
      throw Exception('Failed to search facilities by name or location: $e');
    }
  }

  /// Fetch facilities by category
  Future<List<FacilityModel>> fetchFacilitiesByCategory(String category) async {
    try {
      logger.i('Fetching facilities by $category category...');
      final snapshot = await _firestore
          .collection(collectionPath)
          .where('category', isEqualTo: category)
          .get();
      logger.i('Fetched ${snapshot.size} $category facilities category.');
      return snapshot.docs
          .map((doc) => FacilityModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      logger.e('Error fetching featured facilities: $e', error: e);
      throw Exception('Failed to fetch featured facilities: $e');
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
