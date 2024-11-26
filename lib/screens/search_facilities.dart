import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/facility_model.dart';
import '../providers/facility_provider.dart';

class SearchFacilitiesScreen extends StatefulWidget {
  const SearchFacilitiesScreen({super.key});

  @override
  State<SearchFacilitiesScreen> createState() => _SearchFacilitiesScreenState();
}

class _SearchFacilitiesScreenState extends State<SearchFacilitiesScreen> {
  final TextEditingController searchController = TextEditingController();

  // Define consistent colors
  final Color primaryColor = const Color(0xFF0A72B1);
  final Color accentColor = const Color(0xFFD9EEF3);
  final Color textColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final facilityProvider = Provider.of<FacilityProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        title: Text(
          'Search Facilities',
          style: theme.textTheme.titleMedium?.copyWith(color: accentColor),
        ),
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: accentColor),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            // Search Field
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search facilities...',
                  hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                  prefixIcon: Icon(Icons.search, color: primaryColor),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
                onChanged: (_) {
                  setState(() {}); // Trigger UI rebuild
                },
              ),
            ),
            const SizedBox(height: 20),
            // Facilities List
            Expanded(
              child: StreamBuilder<List<FacilityModel>>(
                stream: facilityProvider.searchFacilities(searchController.text),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: theme.textTheme.bodyMedium?.copyWith(color: primaryColor),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'No facilities found.',
                        style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
                      ),
                    );
                  } else {
                    final facilities = snapshot.data!;
                    return ListView.builder(
                      itemCount: facilities.length,
                      itemBuilder: (context, index) {
                        final facility = facilities[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to facility details
                            Navigator.pushNamed(context, '/facility-details', arguments: facility);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  facility.name,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  facility.location,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: textColor.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
