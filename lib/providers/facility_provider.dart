import 'package:flutter/cupertino.dart';

import '../models/facility_model.dart';
import '../services/facility_service.dart';

class FacilityProvider with ChangeNotifier {
  final FacilityService _facilityService = FacilityService();

  List<FacilityModel> _facilities = [];

  List<FacilityModel> get facilities => _facilities;

  Future<void> fetchFacilities() async {
    _facilities = await _facilityService.getFacilities();
    notifyListeners();
  }
}
