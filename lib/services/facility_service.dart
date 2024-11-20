import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/facility_model.dart';

class FacilityService {
  final CollectionReference facilitiesCollection = FirebaseFirestore.instance.collection('facilities');

  Future<List<FacilityModel>> getFacilities() async {
    try {
      final querySnapshot = await facilitiesCollection.get();
      return querySnapshot.docs.map((doc) {
        return FacilityModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching facilities: $e');
      return [];
    }
  }
}
