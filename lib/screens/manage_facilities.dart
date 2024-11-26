import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/facility_provider.dart';
import '../models/facility_model.dart';

class ManageFacilitiesScreen extends StatefulWidget {
  const ManageFacilitiesScreen({super.key});

  @override
  State<ManageFacilitiesScreen> createState() => _ManageFacilitiesScreenState();
}

class _ManageFacilitiesScreenState extends State<ManageFacilitiesScreen> {
  final Color primaryColor = const Color(0xFF0A72B1);
  final Color accentColor = const Color(0xFFD9EEF3);
  final Color textColor = Colors.black;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<FacilityProvider>(context, listen: false);
    provider.fetchFacilities(); // Fetch facilities when the screen is loaded
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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

            // Consumer to listen to changes in the FacilityProvider
            Consumer<FacilityProvider>(
              builder: (context, provider, child) {
                final facilities = provider.facilities;

                if (facilities.isEmpty) {
                  return Center(
                    child: Text(
                      'No facilities available.',
                      style: theme.textTheme.bodyMedium?.copyWith(color: primaryColor),
                    ),
                  );
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: facilities.length,
                    itemBuilder: (context, index) {
                      final facility = facilities[index];
                      return ListTile(
                        leading: Icon(Icons.location_city, color: primaryColor),
                        title: Text(facility.name, style: TextStyle(color: textColor)),
                        subtitle: Text(facility.location, style: const TextStyle(color: Colors.grey)),
                        trailing: Icon(Icons.edit, color: primaryColor),
                        onTap: () {
                          // Handle editing the facility
                        },
                      );
                    },
                  ),
                );
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
