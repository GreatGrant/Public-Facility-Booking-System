import 'package:flutter/material.dart';
import '../models/facility_model.dart';
import '../services/facility_service.dart';

class FacilityProvider with ChangeNotifier {
  final FacilityService _facilityService = FacilityService();
  List<FacilityModel> _featuredFacilities = []; // Store featured facilities

  List<FacilityModel> _facilities = [];
  bool _isLoading = false;
  String? _error;
  int _totalFacilities = 0; // New property for storing total facilities

  List<FacilityModel> get facilities => _facilities;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get totalFacilities => _totalFacilities; // Getter for total facilities
  List<FacilityModel> get featuredFacilities => _featuredFacilities; // Getter for featured facilities

  // Fetch all facilities
  Future<void> fetchFacilities() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _facilities = await _facilityService.fetchAllFacilities();
    } catch (e) {
      _error = e.toString();
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

    try {
      _facilities = await _facilityService.fetchFacilitiesByCategory(category);
    } catch (e) {
      _error = e.toString();
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

    try {
      _featuredFacilities = await _facilityService.fetchFeaturedFacilities();
    } catch (e) {
      _error = e.toString();
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

    try {
      _totalFacilities = await _facilityService.fetchTotalFacilities();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new facility
  Future<void> addFacility(FacilityModel facility) async {
    try {
      await _facilityService.createFacility(facility);
      _facilities.add(facility);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }
  }

  // Update a facility
  Future<void> updateFacility(String id, FacilityModel updatedFacility) async {
    try {
      await _facilityService.updateFacility(id, updatedFacility);
      final index = _facilities.indexWhere((facility) => facility.id == id);
      if (index != -1) {
        _facilities[index] = updatedFacility;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
    }
  }

  // Delete a facility
  Future<void> deleteFacility(String id) async {
    try {
      await _facilityService.deleteFacility(id);
      _facilities.removeWhere((facility) => facility.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }
  }
}
