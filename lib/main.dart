import 'package:facility_boking/models/booking_model.dart';
import 'package:facility_boking/providers/auth_provider.dart';
import 'package:facility_boking/providers/bookings_provider.dart';
import 'package:facility_boking/providers/facility_provider.dart';
import 'package:facility_boking/providers/user_provider.dart';
import 'package:facility_boking/screens/ModifyBookingScreen.dart';
import 'package:facility_boking/screens/account_details.dart';
import 'package:facility_boking/screens/add_facility_screen.dart';
import 'package:facility_boking/screens/admin_dashboard.dart';
import 'package:facility_boking/screens/booking_confirmation.dart';
import 'package:facility_boking/screens/booking_details.dart';
import 'package:facility_boking/screens/bookings_history.dart';
import 'package:facility_boking/screens/bookings_screen.dart';
import 'package:facility_boking/screens/calendar_screen.dart';
import 'package:facility_boking/screens/categories_screen.dart';
import 'package:facility_boking/screens/edit_facility_screen.dart';
import 'package:facility_boking/screens/facilities_screen.dart';
import 'package:facility_boking/screens/facility_details_screen.dart';
import 'package:facility_boking/screens/forgot_password_screen.dart';
import 'package:facility_boking/screens/home_screen.dart';
import 'package:facility_boking/screens/login_screen.dart';
import 'package:facility_boking/screens/manage_facilities.dart';
import 'package:facility_boking/screens/manage_users_screen.dart';
import 'package:facility_boking/screens/payment_screen.dart';
import 'package:facility_boking/screens/payment_success_screen.dart';
import 'package:facility_boking/screens/profile_screen.dart';
import 'package:facility_boking/screens/reports_screen.dart';
import 'package:facility_boking/screens/search_facilities.dart';
import 'package:facility_boking/screens/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        ChangeNotifierProvider(create: (_) => BookingsProvider()),
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
        '/booking-details': (context) => BookingDetailsScreen(booking: ModalRoute.of(context)!.settings.arguments as BookingModel),
        '/modify-booking' : (context) => ModifyBookingScreen(booking: ModalRoute.of(context)!.settings.arguments as BookingModel),
        '/booking-history' : (context) => const BookingHistoryScreen(),
        '/facilities-screen' : (context) => const FacilitiesScreen(),
        '/search-facilities' : (context) => const SearchFacilitiesScreen(),
        '/category-screen' : (context) => const CategoryScreen(),
        '/reports-screen' : (context) => const ReportsScreen(),
        '/bookings' : (context) => const BookingsScreen(),
        '/manage-users' : (context) => ManageUsersScreen(),
        '/edit-facility' : (context) => EditFacilityScreen(facility: ModalRoute.of(context)!.settings.arguments as FacilityModel),
      },
    );
  }
}

