import 'package:facility_boking/models/facility_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/booking_model.dart';
import '../providers/facility_provider.dart';
import '../providers/user_provider.dart';
import '../reusable_widgets.dart';
import '../widgets.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Define consistent colors
  final Color primaryColor = const Color(0xFF0A72B1);
  final Color accentColor = const Color(0xFFD9EEF3);
  final Color textColor = Colors.black;

  @override
  void initState() {
    super.initState();
    // Fetch featured facilities when the screen loads
    Provider.of<FacilityProvider>(context, listen: false).fetchFeaturedFacilities();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);

    // Stream user bookings
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userBookingsStream = userProvider.streamUserBookings(userId);

    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        title: Text(
          'Public Facility Booking',
          style: theme.textTheme.titleMedium?.copyWith(color: accentColor),
        ),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: accentColor),
            onPressed: () {
              // Handle notifications
            },
          ),
          IconButton(
            icon: Icon(Icons.person, color: accentColor),
            onPressed: () {
              Navigator.pushNamed(context, '/profile-dashboard');
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
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/search-facilities');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                  child: Row(
                    children: [
                      Icon(Icons.search, color: primaryColor, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        'Search facilities...',
                        style: TextStyle(
                          color: textColor.withOpacity(0.7),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Categories
              Text(
                'Categories',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 18,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600
                      ? 4 // For larger screens (e.g., tablets or landscape mode)
                      : 3, // Default for small screens
                  crossAxisSpacing: 20, // Adds space between items
                  mainAxisSpacing: 20, // Adds space between items
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6, // Updated to reflect 6 categories
                itemBuilder: (context, index) {
                  // Define category details in lists
                  final icons = [
                    Icons.event,             // Event Centers
                    Icons.sports_soccer,     // Sports Facilities
                    Icons.place,             // Cultural Sites
                    Icons.meeting_room,      // Conference Halls
                    Icons.brush,             // Art Galleries
                    Icons.group_add,         // Community Halls
                  ];
                  final labels = [
                    "Events Center",
                    "Sports Center",
                    "Cultural Sites",
                    "Conference Halls",
                    "Art Galleries",
                    "Community Halls",
                  ];

                  return QuickActionCard(
                    icon: icons[index],
                    label: labels[index],
                    onTap: () {
                      // Pass the selected category to the next screen
                      Navigator.pushNamed(
                        context,
                        '/category-screen', // The screen that will display the facilities for the selected category
                        arguments: labels[index], // Pass category label or other data
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),

              // Featured Facilities
              Text(
                'Featured Facilities',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 18,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Consumer<FacilityProvider>(
                builder: (context, provider, child) {
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.featuredFacilities.length,
                      itemBuilder: (context, index) {
                        final facility = provider.featuredFacilities[index];
                        return FacilityCard(
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
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Booking History CTA
              // Recent Bookings Section
              StreamBuilder<List<BookingModel>>(
                stream: userBookingsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error fetching bookings: ${snapshot.error}',
                        style: theme.textTheme.bodyMedium?.copyWith(color: primaryColor),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'No recent bookings available.',
                        style: theme.textTheme.bodyMedium?.copyWith(color: primaryColor),
                      ),
                    );
                  }

                  // Limit to the first two bookings
                  final bookings = snapshot.data!.take(2).toList(); // Take the first 2 bookings

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and "View All" button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Bookings',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontSize: 18,
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigate to Booking History
                                Navigator.pushNamed(context, '/booking-history');
                              },
                              child: Text(
                                'View All',
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Booking list
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: bookings.length,
                        itemBuilder: (context, index) {
                          final booking = bookings[index];

                          return ListTile(
                            leading: Icon(Icons.history, color: primaryColor),
                            title: Text(
                              booking.facilityName,
                              style: TextStyle(color: textColor),
                            ),
                            subtitle: Text(
                              'Last Booked: ${booking.bookedAt.toLocal().toString().substring(0, 10)}', // Formatting the date
                              style: TextStyle(color: textColor.withOpacity(0.7)),
                            ),
                            trailing: Icon(Icons.arrow_forward, color: primaryColor),
                            onTap: () {
                              // Navigate to booking details page
                              Navigator.pushNamed(
                                context,
                                '/booking-details',
                                arguments: booking,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to Booking Page
          Navigator.pushNamed(context, '/facilities-screen');
        },
        label: Text('Book Now', style: TextStyle(color: accentColor)),
        icon: Icon(Icons.add, color: accentColor),
        backgroundColor: primaryColor,
      ),
    );
  }
}

