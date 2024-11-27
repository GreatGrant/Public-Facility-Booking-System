import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../models/booking_model.dart';

class BookingDetailsScreen extends StatelessWidget {
  final BookingModel booking;

  const BookingDetailsScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Format the date and time
    final formattedDate = DateFormat('yyyy-MM-dd').format(booking.bookedAt);
    final formattedTime = DateFormat('HH:mm').format(booking.bookedAt);

    // Determine status color
    Color getStatusColor(String status) {
      switch (status) {
        case 'Pending':
          return Colors.orange;
        case 'Confirmed':
          return Colors.green;
        case 'Cancelled':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking Details',
          style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0A72B1), // Primary color
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Facility Name
            Text(
              booking.facilityName,
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Booking Date and Time
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Date: $formattedDate',
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Time: $formattedTime',
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Booking Status with Color
            Row(
              children: [
                const Icon(Icons.info, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Booking Status: ',
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
                ),
                Text(
                  booking.status,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: getStatusColor(booking.status),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Cancel/Modify Button Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cancel Booking Button
                ElevatedButton(
                  onPressed: false ? () {
                    Navigator.pushNamed(context, '/modify-booking', arguments: booking);
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: false ? Colors.blue : Colors.grey,
                  ),
                  child: const Text('Cancel Booking', style: TextStyle(color: Colors.white)),
                ),
                // Modify Booking Button
                ElevatedButton(
                  onPressed: false ? () {
                    Navigator.pushNamed(context, '/modify-booking', arguments: booking);
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: false ? Colors.blue : Colors.grey,
                  ),
                  child: const Text('Modify Booking', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
