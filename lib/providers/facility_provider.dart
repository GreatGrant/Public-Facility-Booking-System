import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';  // Import logger
import '../models/facility_model.dart';
import '../services/facility_service.dart';

class FacilityProvider with ChangeNotifier {
  final FacilityService _facilityService = FacilityService();
  final Logger logger = Logger(); // Create an instance of Logger
  double _totalRevenue = 0.0;

  List<FacilityModel> _featuredFacilities = [];
  List<FacilityModel> _categorisedFacilities = [];
  List<FacilityModel> _facilities = [];
  bool _isLoading = false;
  String? _error;
  int _totalFacilities = 0;

  List<FacilityModel> get facilities => _facilities;
  double get totalRevenue => _totalRevenue;

  bool get isLoading => _isLoading;
  String? get error => _error;
  int get totalFacilities => _totalFacilities;
  List<FacilityModel> get featuredFacilities => _featuredFacilities;
  List<FacilityModel> get categorisedFacilities => _categorisedFacilities;


  // Fetch all facilities
  Future<void> fetchFacilities() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    logger.i('Fetching all facilities...');

    try {
      _facilities = await _facilityService.fetchAllFacilities();
      logger.i('Fetched ${_facilities.length} facilities.');
    } catch (e) {
      _error = 'Failed to fetch facilities. Please try again.';
      logger.e('Error fetching all facilities: $e', error: e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch facilities by category
  Future<void> fetchFacilitiesByCategory(String category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    logger.i('Fetching $category facilities...');

    try {
      _categorisedFacilities = await _facilityService.fetchFacilitiesByCategory(category);
      logger.i('Fetched ${_categorisedFacilities.length} categorised facilities.');
    } catch (e) {
      _error = 'Failed to fetch $category categorised facilities. Please try again.';
      logger.e('Error fetching $category categorised facilities: $e', error: e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch featured facilities
  Future<void> fetchFeaturedFacilities() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    logger.i('Fetching featured facilities...');

    try {
      _featuredFacilities = await _facilityService.fetchFeaturedFacilities();
      logger.i('Fetched ${_featuredFacilities.length} featured facilities.');
    } catch (e) {
      _error = 'Failed to fetch featured facilities. Please try again.';
      logger.e('Error fetching featured facilities: $e', error: e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch total facilities count
  Future<void> fetchTotalFacilities() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    logger.i('Fetching total facilities count...');

    try {
      _totalFacilities = await _facilityService.fetchTotalFacilities();
      logger.i('Total facilities count: $_totalFacilities');
    } catch (e) {
      _error = 'Failed to fetch total facilities count. Please try again.';
      logger.e('Error fetching total facilities count: $e', error: e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new facility
  Future<void> addFacility(FacilityModel facility) async {
    logger.i('Adding new facility: ${facility.name}...');
    try {
      await _facilityService.createFacility(facility);
      _facilities.add(facility);
      logger.i('Facility added: ${facility.name}');
      notifyListeners();
      fetchFacilities();
    } catch (e) {
      _error = 'Failed to add facility. Please try again.';
      logger.e('Error adding facility: $e', error: e);
    }
  }

  // Update a facility
  Future<void> updateFacility(FacilityModel updatedFacility) async {
    logger.i('Updating facility with ID: $updatedFacility.id...');

    try {
      await _facilityService.updateFacility(updatedFacility.id, updatedFacility);
      final index = _facilities.indexWhere((facility) => facility.id == updatedFacility.id);
      if (index != -1) {
        _facilities[index] = updatedFacility;
        logger.i('Facility updated with ID: $updatedFacility.id');
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to update facility. Please try again.';
      logger.e('Error updating facility with ID: $updatedFacility.id: $e', error: e);
    }
  }

  // Delete a facility
  Future<void> deleteFacility(String id) async {
    logger.i('Deleting facility with ID: $id...');
    try {
      await _facilityService.deleteFacility(id);
      _facilities.removeWhere((facility) => facility.id == id);
      logger.i('Facility deleted with ID: $id');
      notifyListeners();
      fetchFacilities();
    } catch (e) {
      _error = 'Failed to delete facility. Please try again.';
      logger.e('Error deleting facility with ID: $id: $e', error: e);
    }
  }

  /// Stream available dates from all facilities (using FacilityService)
  Stream<List<DateTime>> streamAvailableDates() async* {
    try {
      yield* _facilityService.streamAvailableDates();
    } catch (e) {
      logger.e('Error fetching available dates: $e');
      yield []; // Or emit a state indicating failure
    }
  }

  // Stream to listen to the total revenue
  // Stream the total revenue from the service
  Stream<double> get streamTotalRevenue {
    return _facilityService.streamTotalRevenue().map((revenue) {
      _totalRevenue = revenue;  // Update the internal state
      notifyListeners();  // Notify listeners when the revenue changes
      return revenue;
    });
  }

  // Search facilities by name or location
  Stream<List<FacilityModel>> searchFacilities(String query) {
    logger.i('Searching facilities by name or location with query: $query...');

    try {
      return _facilityService.searchFacilitiesByNameOrLocation(query);
    } catch (e) {
      logger.e('Error searching facilities by name or location: $e');
      return const Stream.empty();
    }
  }

}
