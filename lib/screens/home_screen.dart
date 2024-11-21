import 'package:facility_boking/models/facility_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:table_calendar/table_calendar.dart';

import '../reusable_widgets.dart';

class HomeScreen extends StatelessWidget {
  // Define consistent colors
  final Color primaryColor = const Color(0xFF0A72B1); // Deep blue
  final Color accentColor = const Color(0xFFD9EEF3); // Light blue
  final Color textColor = Colors.black;

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              Navigator.pushNamed(context, '/profile-screen');
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
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return _buildFacilityCard(
                      'Facility ${index + 1}',
                      'https://via.placeholder.com/150',
                      context,
                      'facility_${index + 1}',
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Booking History CTA
              Row(
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
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                ],
              ),
              ListTile(
                leading: Icon(Icons.history, color: primaryColor),
                title: Text(
                  'Facility Name',
                  style: TextStyle(color: textColor),
                ),
                subtitle: Text(
                  'Last Booked: 10th Nov 2024',
                  style: TextStyle(color: textColor.withOpacity(0.7)),
                ),
                trailing: Icon(Icons.arrow_forward, color: primaryColor),
                onTap: () {
                  // Open booking details
                },
              ),
              const SizedBox(height: 20),

              // Availability Calendar
              Text(
                'Availability Calendar',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 18,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2023, 1, 1),
                    lastDay: DateTime.utc(2025, 12, 31),
                    focusedDay: DateTime.now(),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: TextStyle(color: Colors.white),
                    ),
                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                      titleTextStyle: TextStyle(color: primaryColor),
                    ),
                    selectedDayPredicate: (day) {
                      return isSameDay(day, DateTime.now());
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      // Handle day selection
                    },
                  ),
                ),
              ),
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

  Widget _buildFacilityCard(
      String title, String imageUrl, BuildContext context, String id) {
    final facility = FacilityModel(
      id: id,
      name: title,
      imageUrl: imageUrl,
      rating: 4.5,
      category: 'Conference Room',
      description: '', isFeatured: true,
      availabilityDates: [DateTime(2024, 11, 19),  DateTime(2024, 11, 21)],
      location: 'Lafia', // Dynamic data
    );

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
                imageUrl: imageUrl,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: const [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Icon(Icons.star_border, color: Colors.amber, size: 16),
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
