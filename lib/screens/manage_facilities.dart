import 'package:flutter/material.dart';

class ManageFacilitiesScreen extends StatelessWidget {
  final Color primaryColor = const Color(0xFF0A72B1);
  final Color accentColor = const Color(0xFFD9EEF3);
  final Color textColor = Colors.black;

  const ManageFacilitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color primaryColor = const Color(0xFF0A72B1); // Deep blue

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Facilities',
          style: theme.textTheme.titleMedium?.copyWith(color: accentColor),
        ),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: accentColor),
            onPressed: () {
              // Handle logout
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Manage Your Facilities',
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 18,
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Here, you'll dynamically load facilities, for now, it's static
            ListTile(
              leading: Icon(Icons.location_city, color: primaryColor),
              title: Text('Facility Name', style: TextStyle(color: textColor)),
              subtitle: Text('Facility Location', style: TextStyle(color: Colors.grey)),
              trailing: Icon(Icons.edit, color: primaryColor),
              onTap: () {
                // Handle editing the facility
              },
            ),
            ListTile(
              leading: Icon(Icons.location_city, color: primaryColor),
              title: Text('Facility Name', style: TextStyle(color: textColor)),
              subtitle: Text('Facility Location', style: TextStyle(color: Colors.grey)),
              trailing: Icon(Icons.edit, color: primaryColor),
              onTap: () {
                // Handle editing the facility
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              onPressed: () {
                // Navigate to Add Facility Screen
                Navigator.pushNamed(context, '/add-facilities');
              },
              child: Text('Add New Facility', style: TextStyle(color: accentColor)),
            ),
          ],
        ),
      ),
    );
  }
}
