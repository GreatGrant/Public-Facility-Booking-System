import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:table_calendar/table_calendar.dart';

class FacilityDetailsScreen extends StatefulWidget {
  final String title;
  final String description;
  final String imageUrl;
  final double rating;

  const FacilityDetailsScreen({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.rating = 4.5,
  });

  @override
  State<FacilityDetailsScreen> createState() => _FacilityDetailsScreenState();
}

class _FacilityDetailsScreenState extends State<FacilityDetailsScreen> {
  late final List<DateTime> availableDates;

  @override
  void initState() {
    super.initState();
    // Example of available dates
    availableDates = [
      DateTime.now(),
      DateTime.now().add(Duration(days: 2)),
      DateTime.now().add(Duration(days: 4)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color primaryColor = const Color(0xFF0A72B1);
    final Color textColor = Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Facility Image
              CachedNetworkImage(
                imageUrl: widget.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) =>
                const Icon(Icons.error, size: 100, color: Colors.red),
              ),
              const SizedBox(height: 16),

              // Facility Title
              Text(
                widget.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),

              // Facility Rating
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    widget.rating.toString(),
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: textColor, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${(widget.rating * 20).toInt()} reviews)',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: textColor.withOpacity(0.6)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Facility Description
              Text(
                'About',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.description,
                style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
              ),
              const SizedBox(height: 16),

              // Availability Calendar
              Text(
                'Availability',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime(2050),
                focusedDay: DateTime.now(),
                calendarFormat: CalendarFormat.month,
                selectedDayPredicate: (day) =>
                    availableDates.any((date) => isSameDay(date, day)),
                onDaySelected: (selectedDay, focusedDay) {
                  final isAvailable = availableDates.any((date) => isSameDay(date, selectedDay));
                  final message = isAvailable
                      ? "This facility is available on ${selectedDay.toLocal()}."
                      : "This facility is not available on ${selectedDay.toLocal()}.";

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Availability"),
                      content: Text(message),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: theme.textTheme.bodySmall!.copyWith(
                    color: Colors.red,
                  ),
                ),
                eventLoader: (day) {
                  return availableDates
                      .where((date) => isSameDay(date, day))
                      .toList();
                },
              ),
              const SizedBox(height: 16),

              // Booking Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Handle booking logic
                  },
                  icon: const Icon(Icons.book, color: Colors.white),
                  label: const Text('Book Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    textStyle: const TextStyle(color: Colors.white),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
