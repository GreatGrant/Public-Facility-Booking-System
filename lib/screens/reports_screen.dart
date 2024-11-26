import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color primaryColor = const Color(0xFF0A72B1); // Deep blue
    final Color accentColor = const Color(0xFFD9EEF3); // Light blue

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
                  _buildReportTile('Revenue Summary', 'Total Revenue: ₦500,000', Icons.attach_money),
                  _buildReportTile('User Activity', 'New Users: 120', Icons.people),
                  _buildReportTile('Bookings Summary', 'Total Bookings: 80', Icons.calendar_today),
                  _buildReportTile('Facility Utilization', 'Facilities Booked: 75%', Icons.location_city),
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
