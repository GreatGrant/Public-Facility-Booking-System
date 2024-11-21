import 'package:facility_boking/providers/auth_provider.dart' as custom_auth;
import 'package:facility_boking/providers/auth_provider.dart';
import 'package:facility_boking/screens/admin_dashboard.dart';
import 'package:facility_boking/screens/home_screen.dart';
import 'package:facility_boking/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<custom_auth.AuthProvider>(context);

    return StreamBuilder<User?>(
      stream: authProvider.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show custom initialization screen while waiting for authentication state
          return const InitializationScreen();
        }

        if (snapshot.hasData) {
          return FutureBuilder<String?>(
            future: authProvider.getUserRole(),
            builder: (context, roleSnapshot) {
              if (roleSnapshot.connectionState == ConnectionState.waiting) {
                // Show custom initialization screen while fetching user role
                return const InitializationScreen();
              }

              if (roleSnapshot.hasData) {
                final role = roleSnapshot.data!;
                if (role == 'admin') {
                  return const AdminDashboard();
                } else {
                  return const HomeScreen();
                }
              } else {
                return const Center(child: Text('Error: Could not fetch user role.'));
              }
            },
          );
        } else {
          return LoginScreen();
        }
      },
    );
  }
}

class InitializationScreen extends StatelessWidget {
  const InitializationScreen({super.key});

  final Color primaryColor = const Color(0xFF0A72B1); // Deep blue
  final Color accentColor = const Color(0xFFD9EEF3); // Light blue
  final Color textColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, accentColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Public Facility\n Booking System',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Initializing...',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: LinearProgressIndicator(
                backgroundColor: Colors.white30,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

