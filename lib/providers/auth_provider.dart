import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facility_boking/screens/admin_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../services/firebase_auth_service.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseAuthService _authService = FirebaseAuthService();

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  String? _username;

  AuthProvider() {
    _authService.authStateChanges().listen((User? user) {
      _user = user;
      if (_user != null) {
        getUserRoleAndUsername();
      }
      notifyListeners();
    });

    _initializePersistence();
  }

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get username => _username;
  User? get currentUser => _firebaseAuth.currentUser;

  // Stream to observe auth state changes
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  // Authentication Actions
  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required String phoneNumber,
    required BuildContext context
  }) async {
    _setLoading(true);
    try {
      _errorMessage = null;
      _user = await _authService.signUpWithEmail(
          name: username,
          email: email,
          password: password,
          mobileNumber: password);

      if (_user != null) {
        await _authService.signUpWithEmail(
            name: username,
            email: email,
            password: password,
            mobileNumber: phoneNumber
        );
        _navigateToHome(context);
      } else {
        _errorMessage = 'Failed to sign up. Please try again.';
      }
    } catch (e) {
      _handleError(e, context);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signIn(String email, String password, BuildContext context) async {
    _setLoading(true);
    try {
      _errorMessage = null;
      _user = await _authService.signInWithEmail(email, password);
      if (_user != null) {
        await navigateBasedOnRole(context);
      } else {
        _errorMessage = 'Failed to sign in. Please try again.';
      }
    } catch (e) {
      _handleError(e, context);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut(BuildContext context) async {
    _setLoading(true);
    try {
      await _authService.signOut();
      _user = null;
      _navigateToLogin(context);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resetPassword(String email) async {
    _setLoading(true);
    try {
      await _authService.resetPassword(email);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> forgotPassword(String email, BuildContext context) async {
    _setLoading(true);
    try {
      await _authService.resetPassword(email);
      _showSnackBar(context, 'Password reset email sent successfully');
    } catch (e) {
      _handleError(e, context);
    } finally {
      _setLoading(false);
    }
  }

  Future<String> getUserRoleAndUsername() async {
    if (_user == null) return '';
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(_user!.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data()!;
        _username = userData['username'];
        notifyListeners();
        return userData['role'] ?? 'user';
      }
    } catch (e) {
      debugPrint("Error retrieving role: $e");
    }
    return 'user';
  }

  // Navigation
  void _navigateToHome(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  LoginScreen()));
  }

  Future<void> navigateBasedOnRole(BuildContext context) async {
    final role = await getUserRoleAndUsername();
    if (role == 'admin') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const AdminDashboard()));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  // Error Handling
  void _handleError(dynamic error, BuildContext context) {
    _errorMessage = error.toString();
    _showSnackBar(context, _errorMessage!);
    notifyListeners();
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // Helper Functions
  void _initializePersistence() {
    _firebaseAuth.setPersistence(Persistence.LOCAL);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<String?> getUserRole() async {
    if (_user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(_user!.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data()!;
        return userData['role'] ?? 'user'; // Return the role or default to 'user'
      }
    }
    return null; // Return null if user is not available or document doesn't exist
  }

}
