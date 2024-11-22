import 'package:flutter/material.dart';

import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _userData;
  final UserService _userService = UserService();

  Map<String, dynamic>? get userData => _userData;

  // Fetch user data
  Future<void> fetchUserData() async {
    try {
      _userData = await _userService.getUserData();
      notifyListeners(); // Notify listeners when data is fetched
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
}
