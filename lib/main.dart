import 'package:facility_boking/models/booking_model.dart';
import 'package:facility_boking/providers/auth_provider.dart';
import 'package:facility_boking/providers/facility_provider.dart';
import 'package:facility_boking/providers/user_provider.dart';
import 'package:facility_boking/screens/account_details.dart';
import 'package:facility_boking/screens/add_facility_screen.dart';
import 'package:facility_boking/screens/admin_dashboard.dart';
import 'package:facility_boking/screens/booking_confirmation.dart';
import 'package:facility_boking/screens/booking_details.dart';
import 'package:facility_boking/screens/calendar_screen.dart';
import 'package:facility_boking/screens/facility_details_screen.dart';
import 'package:facility_boking/screens/forgot_password_screen.dart';
import 'package:facility_boking/screens/home_screen.dart';
import 'package:facility_boking/screens/login_screen.dart';
import 'package:facility_boking/screens/manage_facilities.dart';
import 'package:facility_boking/screens/payment_screen.dart';
import 'package:facility_boking/screens/payment_success_screen.dart';
import 'package:facility_boking/screens/profile_screen.dart';
import 'package:facility_boking/screens/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_wrapper.dart';
import 'models/facility_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()..fetchUserData()),
        ChangeNotifierProvider(create: (_) => FacilityProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facility Booking',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/home-screen': (context) => const HomeScreen(),
        '/calendar-screen': (context) => const CalendarScreen(),
        '/facility-details': (context) => FacilityDetailsScreen(
          facilityModel: ModalRoute.of(context)!.settings.arguments as FacilityModel,
        ),
        '/booking-confirmation': (context) => BookingConfirmationScreen(
          facilityModel: ModalRoute.of(context)!.settings.arguments as FacilityModel,
        ),
        '/admin-dashboard': (context) => const AdminDashboard(),
        '/profile-dashboard': (context) => const ProfileScreen(),
        '/manage-facilities': (context) => const ManageFacilitiesScreen(),
        '/add-facilities': (context) => const AddFacilityScreen(),
        '/payment-screen': (context) => const PaymentScreen(),
        '/payment-success': (context) => const PaymentSuccessScreen(),
        '/account-details': (context) => const AccountDetailsScreen(),
        '/booking-details': (context) => BookingDetailsScreen(booking: ModalRoute.of(context)!.settings.arguments as BookingModel)
      },
    );
  }
}

