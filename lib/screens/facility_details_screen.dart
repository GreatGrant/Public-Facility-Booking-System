import 'package:facility_boking/models/facility_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:table_calendar/table_calendar.dart';

import '../helpers/date_formatter.dart';
import '../widgets/loading_indicator.dart';

class FacilityDetailsScreen extends StatefulWidget {
  final FacilityModel facilityModel;

  const FacilityDetailsScreen({
    super.key, required this.facilityModel,
  });

  @override
  State<FacilityDetailsScreen> createState() => _FacilityDetailsScreenState();
}

class _FacilityDetailsScreenState extends State<FacilityDetailsScreen> {
  late final List<DateTime> availableDates;

  @override
  void initState() {
    super.initState();
    // Assuming facilityModel contains a List<DateTime> for available dates
    availableDates = widget.facilityModel.availabilityDates;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const Color primaryColor = Color(0xFF0A72B1);
    const Color textColor = Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.facilityModel.name,
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
                imageUrl: widget.facilityModel.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: LoadingIndicator(),
                ),
                errorWidget: (context, url, error) =>
                const Icon(Icons.broken_image, size: 100, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              // Facility Title
              Text(
                widget.facilityModel.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),

              // Facility Rating
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    widget.facilityModel.rating.toString(),
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: textColor, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${(widget.facilityModel.rating * 20).toInt()} reviews)',
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
                widget.facilityModel.description,
                style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
              ),
              const SizedBox(height: 16),

              // Facility Location
              Text(
                'Location',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.facilityModel.location, // Display the location
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
                  final DateTime selectedDateInWAT = convertToWAT(selectedDay);

                  final message = isAvailable
                      ? "This facility is available on ${formatter.format(selectedDateInWAT)} WAT."
                      : "This facility is not available on ${formatter.format(selectedDateInWAT)} WAT.";

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
                  selectedDecoration: const BoxDecoration(
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
                    Navigator.pushNamed(context, '/booking-confirmation', arguments: widget.facilityModel);
                  },
                  icon: const Icon(Icons.book, color: Colors.white),
                  label: const Text('Book Now', style: TextStyle(color: Colors.white),),
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
