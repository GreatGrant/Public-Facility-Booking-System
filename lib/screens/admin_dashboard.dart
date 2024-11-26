import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bookings_provider.dart';
import '../providers/facility_provider.dart';

class AdminDashboard extends StatefulWidget {

  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final Color primaryColor = const Color(0xFF0A72B1);
 // Deep blue
  final Color accentColor = const Color(0xFFD9EEF3);
 // Light blue
  final Color textColor = Colors.black;

  @override
  void initState() {
    super.initState();
    // Call fetchTotalFacilities when the screen is first loaded
    final provider = Provider.of<FacilityProvider>(context, listen: false);
    provider.fetchTotalFacilities();

    final bookingsProvider = Provider.of<BookingsProvider>(context, listen: false);
    bookingsProvider.fetchTodaysBookings();

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: theme.textTheme.titleMedium?.copyWith(color: accentColor),
        ),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: accentColor),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Overview Section
              Text(
                'Overview',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 18,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Using LayoutBuilder to make the grid responsive
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Consumer<FacilityProvider>(
                        builder: (context, provider, child) {
                          return _buildStatCard(
                            'Total Facilities',
                            provider.totalFacilities.toString(),
                            Icons.location_city,
                          );
                        },
                      ),
                      _buildStatCard('Active Users', '150', Icons.people),
                      Consumer<BookingsProvider>(
                        builder: (context, provider, child) {
                          return _buildStatCard(
                            'Bookings Today',
                            provider.todaysBookings.length.toString(),
                            Icons.calendar_today,
                          );
                        },
                      ),
                      _buildStatCard('Revenue', '₦500', Icons.attach_money),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),

              // Facility Management
              Text(
                'Facility Management',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 18,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.add, color: primaryColor),
                title: Text('Add Facility', style: TextStyle(color: textColor)),
                onTap: () {
                  Navigator.pushNamed(context, '/add-facilities');
                },
              ),
              ListTile(
                leading: Icon(Icons.edit, color: primaryColor),
                title: Text('Manage Facilities', style: TextStyle(color: textColor)),
                onTap: () {
                  Navigator.pushNamed(context, '/manage-facilities');
                },
              ),
              const SizedBox(height: 20),

              // Booking Management
              Text(
                'Booking Management',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 18,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.book_online, color: primaryColor),
                title: Text('View Bookings', style: TextStyle(color: textColor)),
                onTap: () {
                  // Navigate to Booking List Screen
                },
              ),
              const SizedBox(height: 20),

              // User Management
              Text(
                'User Management',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 18,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.people, color: primaryColor),
                title: Text('Manage Users', style: TextStyle(color: textColor)),
                onTap: () {

                },
              ),
              const SizedBox(height: 20),

              // Reports
              Text(
                'Reports',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 18,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.pie_chart, color: primaryColor),
                title: Text('View Reports', style: TextStyle(color: textColor)),
                onTap: () {
                  // Navigate to Reports Screen
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start, // Aligns the text properly
              children: [
                Icon(icon, size: 30, color: primaryColor),
                const SizedBox(width: 10),
                // Use Expanded to allow the title to wrap
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                    softWrap: true,  // Allows wrapping of text if needed
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8), // Space between the title and the value
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              softWrap: true,  // Allows wrapping of the value text if needed
            ),
          ],
        ),
      ),
    );
  }
}
