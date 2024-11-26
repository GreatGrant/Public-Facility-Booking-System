import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/facility_provider.dart';
import '../widgets/facilities_card.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final Color primaryColor = const Color(0xFF0A72B1);
  final Color accentColor = const Color(0xFFD9EEF3);
  final Color textColor = Colors.black;

  String? category;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final routeArgs = ModalRoute.of(context)?.settings.arguments as String?;
      if (routeArgs != null) {
        setState(() {
          category = routeArgs;
        });
        Provider.of<FacilityProvider>(context, listen: false)
            .fetchFacilitiesByCategory(routeArgs);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        title: Text(
          category ?? 'Loading...',
          style: theme.textTheme.titleMedium?.copyWith(color: accentColor),
        ),
        backgroundColor: primaryColor,
      ),
      body: category == null
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<FacilityProvider>(
          builder: (context, facilityProvider, child) {
            if (facilityProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (facilityProvider.error != null) {
              return Center(
                child: Text(
                  facilityProvider.error!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            }

            final facilities = facilityProvider.categorisedFacilities;
            if (facilities.isEmpty) {
              return const Center(
                child: Text(
                  "No facilities available in this category.",
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.8, // Adjust based on card design
              ),
              itemCount: facilities.length,
              itemBuilder: (context, index) {
                final facility = facilities[index];

                return FacilitiesCard(
                  facility: facility,
                  onTap: () {
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
    );
  }
}
