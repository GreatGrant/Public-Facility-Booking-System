import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  Future<void> fetchUser(String id) async {
    final user = await _userService.getUser(id);
    if (user != null) {
      _currentUser = user;
      notifyListeners();
    }
  }

  Future<void> updateUser(UserModel user) async {
    await _userService.updateUser(user);
    _currentUser = user;
    notifyListeners();
  }
}
