import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../models/booking_model.dart';

class BookingDetailsScreen extends StatelessWidget {
  final BookingModel booking;

  // Constructor to receive the booking details
  const BookingDetailsScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Format the date and time
    final formattedDate = DateFormat('yyyy-MM-dd').format(booking.bookedAt);
    final formattedTime = DateFormat('HH:mm').format(booking.bookedAt);

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
                Icon(Icons.access_time, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Time: $formattedTime',
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Additional Booking Details (e.g., status, number of people, etc.)
            // These fields can be expanded as needed
            Text(
              'Booking Status: ${booking.status}', // Assuming 'status' is a field in BookingModel
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 10),

            // Optionally, you can display other details like location, booking ID, etc.

            // Cancel/Modify Button Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cancel Booking Button
                ElevatedButton(
                  onPressed: () {
                    // Handle cancellation logic
                    _showCancellationDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Cancel Booking',style: TextStyle(color: Colors.white),),
                ),
                // Modify Booking Button
                ElevatedButton(
                  onPressed: () {
                    // Handle modification logic
                    Navigator.pushNamed(context, '/modify-booking', arguments: booking);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
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

  // Cancel Booking Confirmation Dialog
  void _showCancellationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close the dialog
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              // Call the function to cancel the booking
              // Assuming you have a function like cancelBooking in your provider or service
              // cancelBooking(booking.id);
              Navigator.of(ctx).pop();
              Navigator.pop(context); // Go back to the previous screen
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
