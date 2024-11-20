import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Public method to set loading status
  void setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  /// Sign up a new user
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required String mobileNumber,
  }) async {
    setLoading(true);
    _errorMessage = null;

    try {
      // Attempt to sign up the user using the AuthService
      await _authService.signUp(
        name: name,
        email: email,
        password: password,
        mobileNumber: mobileNumber,
      );
      return true;  // Return true if signup is successful
    } catch (e) {
      _errorMessage = e.toString();
      return false; // Return false if there's an error
    } finally {
      setLoading(false);
    }
  }

  /// Sign in an existing user
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    setLoading(true);
    _errorMessage = null;

    try {
      await _authService.signIn(
        email: email,
        password: password,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setLoading(false);
    }
  }

  /// Forgot password - send a password reset email
  Future<void> forgotPassword({required String email}) async {
    setLoading(true);
    _errorMessage = null;

    try {
      await _authService.forgotPassword(email: email);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setLoading(false);
    }
  }
}
