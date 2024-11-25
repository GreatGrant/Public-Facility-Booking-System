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

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Define consistent colors
  final Color primaryColor = const Color(0xFF0A72B1);
 // Deep blue
  final Color accentColor = const Color(0xFFD9EEF3);
 // Light blue
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
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search facilities...',
                  hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                  prefixIcon: Icon(Icons.search, color: primaryColor),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
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
                itemCount: 3, // Replace with dynamic count
                itemBuilder: (context, index) {
                  return QuickActionCard(
                    icon: index == 0
                        ? Icons.sports_soccer
                        : index == 1
                        ? Icons.meeting_room
                        : Icons.pool,
                    label: index == 0
                        ? "Sports Halls"
                        : index == 1
                        ? "Conference Rooms"
                        : "Pools",
                    onTap: () {
                      // Navigate to the respective category
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
                        return _buildFacilityCard(facility, context);
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Booking History CTA
              // Recent Bookings Section
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
              const SizedBox(height: 20),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to Booking Page
        },
        label: Text('Book Now', style: TextStyle(color: accentColor)),
        icon: Icon(Icons.add, color: accentColor),
        backgroundColor: primaryColor,
      ),
    );
  }

  Widget _buildFacilityCard(FacilityModel model, BuildContext context) {
    final facility = FacilityModel(
      id: model.id,
      name: model.name,
      imageUrl: model.imageUrl,
      rating: model.rating,
      category: model.category,
      description: model.description,
      isFeatured: true,
      availabilityDates: model.availabilityDates,
      location: model.location,
      price: model.price, // Dynamic data
    );

    // Determine the number of full stars, half stars, and empty stars based on rating
    int fullStars = model.rating.floor();
    int halfStars = (model.rating - fullStars >= 0.5) ? 1 : 0;
    int emptyStars = 5 - fullStars - halfStars;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/facility-details',
          arguments: facility,
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: SizedBox(
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: model.imageUrl,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  model.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,  // Truncate the name if it's too long
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    // Full stars
                    for (int i = 0; i < fullStars; i++)
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                    // Half star (optional)
                    if (halfStars > 0)
                      const Icon(Icons.star_half, color: Colors.amber, size: 16),
                    // Empty stars
                    for (int i = 0; i < emptyStars; i++)
                      const Icon(Icons.star_border, color: Colors.amber, size: 16),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Details',
                  style: TextStyle(color: primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
