import 'package:facility_boking/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/facility_model.dart';
import '../providers/facility_provider.dart';

import 'package:flutter/material.dart';
import '../models/facility_model.dart';
import '../widgets/facilities_card.dart';

class FacilitiesScreen extends StatefulWidget {
  const FacilitiesScreen({super.key});

  @override
  State<FacilitiesScreen> createState() => _FacilitiesScreenState();
}

class _FacilitiesScreenState extends State<FacilitiesScreen> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<FacilityProvider>(context, listen: false);
    provider.fetchFacilities();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: GlobalVariables.accentColor,
      appBar: AppBar(
        title: Text(
          'Facilities',
          style: theme.textTheme.titleMedium?.copyWith(color: GlobalVariables.accentColor),
        ),
        backgroundColor: GlobalVariables.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Search Bar
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/search-facilities');
              },
              child: IgnorePointer(
                ignoring: true,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search facilities...',
                    hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                    prefixIcon: const Icon(Icons.search, color: GlobalVariables.primaryColor),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Facilities List Header
            Text(
              'Available Facilities',
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 18,
                color: GlobalVariables.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Facilities Grid
            Expanded(
              child: Consumer<FacilityProvider>(
                builder: (context, provider, child) {
                  final facilities = provider.facilities;

                  if (facilities.isEmpty) {
                    return Center(
                      child: Text(
                        'No facilities available.',
                        style: theme.textTheme.bodyMedium?.copyWith(color: GlobalVariables.accentColor),
                      ),
                    );
                  }

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Adjust for different device sizes
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                    ),
                    itemCount: facilities.length,
                    itemBuilder: (context, index) {
                      final facility = facilities[index];

                      return FacilitiesCard(
                        facility: facility,
                        onTap: () {
                          // Navigate to the Facility Details screen
                          Navigator.pushNamed(
                            context,
                            '/facility-details',
                            arguments: facility,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


