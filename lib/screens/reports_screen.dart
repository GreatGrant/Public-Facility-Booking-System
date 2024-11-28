import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bookings_provider.dart';
import '../providers/facility_provider.dart';
import '../providers/user_provider.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color primaryColor = const Color(0xFF0A72B1); // Deep blue
    final Color accentColor = const Color(0xFFD9EEF3); // Light blue

    @override
    void initState() {
      super.initState();
      // Call fetchTotalFacilities when the screen is first loaded
      final facilitiesProvider = Provider.of<FacilityProvider>(context, listen: false);
      facilitiesProvider.fetchTotalFacilities();


      final bookingsProvider = Provider.of<BookingsProvider>(context, listen: false);
      bookingsProvider.fetchTodaysBookings();

      final usersProvider = Provider.of<UserProvider>(context, listen: false);
      usersProvider.getTotalUsers();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reports',
          style: theme.textTheme.titleMedium?.copyWith(color: accentColor),
        ),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: accentColor),
            onPressed: () async {
              // Handle logout
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Overview Section
            Text(
              'Report Overview',
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 18,
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Example Report List
            Expanded(
              child: ListView(
                children: [
                  // Consumer<FacilityProvider>(
                  //   builder: (context, facilityProvider, child) {
                  //     return _buildReportTile(
                  //         'Revenue Summary',
                  //         'Total Revenue: ₦${facilityProvider.totalRevenue}',
                  //         Icons.attach_money);
                  //   },
                  // ),
                  Consumer<UserProvider>(
                    builder: (context, provider, child) {
                      return _buildReportTile(
                          'User Activity',
                          'New Users: ${provider.totalUsers}',
                          Icons.people
                      );
                    },
                  ),
                  // Consumer<BookingsProvider>(
                  //   builder: (context, provider, child) {
                  //     return _buildReportTile(
                  //         'Bookings Summary',
                  //         'Total Bookings: ${provider.todaysBookings}',
                  //         Icons.calendar_today);
                  //   },
                  // ),
                  // // Consumer<FacilityProvider>(
                  //   builder: (context, facilityProvider, child) {
                  //     return _buildReportTile(
                  //           'Facility Utilization',
                  //           'Facilities Booked: ${facilityProvider.bookedFacilitiesPercentage.toStringAsFixed(2)}%',
                  //           Icons.location_city
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportTile(String title, String subtitle, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0A72B1)),  // Deep blue
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        onTap: () {
          // You can navigate to a detailed report screen if necessary
        },
      ),
    );
  }
}
