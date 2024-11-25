import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/facility_model.dart';
import '../providers/facility_provider.dart';

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
      appBar: AppBar(
        title: Text(
          'Facilities',
          style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search facilities...',
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Facilities List
            Text(
              'Available Facilities',
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 18,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<FacilityProvider>(
                builder: (context, provider, child) {
                  final facilities = provider.facilities;

                  if (facilities.isEmpty) {
                    return Center(
                      child: Text(
                        'No facilities available.',
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.blue),
                      ),
                    );
                  }

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // For smaller devices or tablets
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: facilities.length,
                    itemBuilder: (context, index) {
                      final facility = facilities[index];

                      return GestureDetector(
                        onTap: () {
                          // Navigate to the Booking screen for the selected facility
                          Navigator.pushNamed(
                            context,
                            '/facility-details',
                            arguments: facility,
                          );
                        },
                        child: Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Facility Image
                              Image.network(
                                facility.imageUrl,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  facility.name,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
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
