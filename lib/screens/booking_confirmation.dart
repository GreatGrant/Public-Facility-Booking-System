import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:cached_network_image/cached_network_image.dart';

import '../models/facility_model.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final FacilityModel facilityModel; // Accept FacilityModel

  const BookingConfirmationScreen({
    super.key,
    required this.facilityModel, // Receive FacilityModel
  });

  @override
  _BookingConfirmationScreenState createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  DateTime? startDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const Color primaryColor = Color(0xFF0A72B1);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Confirm Booking',
          style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: Padding(
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
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) =>
              const Icon(Icons.error, size: 100, color: Colors.red),
            ),
            const SizedBox(height: 16),

            // Facility Name
            Text(
              widget.facilityModel.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),

            // Available Dates Section
            Text(
              'Available Dates:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            // List of available dates
            Wrap(
              spacing: 8.0, // Horizontal space between chips
              runSpacing: 8.0, // Vertical space between lines
              children: widget.facilityModel.availabilityDates.map((date) {
                String formattedDate = DateFormat.yMMMd().format(date);
                return GestureDetector(
                  onTap: () => _pickStartDate(date),
                  child: Chip(
                    label: Text(formattedDate),
                    backgroundColor: startDate == date ? primaryColor : Colors.grey[300],
                    labelStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: startDate == date ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Confirm Booking Button
            Center(
              child: ElevatedButton.icon(
                onPressed: _confirmBooking,
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: const Text('Confirm Booking', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Cancel Button (optional)
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to the previous screen
                },
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickStartDate(DateTime selectedDate) {
    setState(() {
      startDate = selectedDate; // Set selected date
    });
  }

  void _confirmBooking() {
    if (startDate != null) {
      Navigator.pushNamed(
        context,
        '/payment-screen',
        arguments: {
          'facilityModel': widget.facilityModel,
          'selectedDate': startDate,
        },
      );
    } else {
      _showErrorDialog('Please select a date for booking.');
    }
  }


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}