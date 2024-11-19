import 'package:facility_boking/screens/calendar_screen.dart';
import 'package:facility_boking/screens/facility_details_screen.dart';
import 'package:facility_boking/screens/forgot_password_screen.dart';
import 'package:facility_boking/screens/home_screen.dart';
import 'package:facility_boking/screens/login_screen.dart';
import 'package:facility_boking/screens/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facility Booking',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/home-screen': (context) => const HomeScreen(),
        '/calendar-screen': (context) => const CalendarScreen(),
        '/facility-details': (context) => const FacilityDetailsScreen(title: '', description: '', imageUrl: ''),
      },
    );
  }
}
