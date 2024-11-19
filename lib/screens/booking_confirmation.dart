import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:cached_network_image/cached_network_image.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final String facilityId;
  final String facilityName;
  final String facilityImageUrl;
  final List<DateTime> availableDates; // Added available dates

  const BookingConfirmationScreen({
    super.key,
    required this.facilityId,
    required this.facilityName,
    required this.facilityImageUrl,
    required this.availableDates, // Received available dates
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
    final Color primaryColor = const Color(0xFF0A72B1);

    // Format the selected date
    String formattedStartDate = startDate != null
        ? DateFormat.yMMMd().format(startDate!)
        : 'Select booking date';

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
              imageUrl: widget.facilityImageUrl,
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
              widget.facilityName,
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
            Column(
              children: widget.availableDates.map((date) {
                String formattedDate = DateFormat.yMMMd().format(date);
                return GestureDetector(
                  onTap: () => _pickStartDate(date),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: startDate == date
                            ? primaryColor
                            : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      formattedDate,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: startDate == date ? primaryColor : null,
                      ),
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
                icon: const Icon(Icons.check_circle),
                label: const Text('Confirm Booking'),
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
      // Show bottom sheet to collect card details after selecting a date
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CardDetailsBottomSheet(
            onConfirm: _approveBooking,
          );
        },
      );
    } else {
      // Show error if no date is selected
      _showErrorDialog('Please select a date for booking.');
    }
  }

  void _approveBooking() {
    // Logic to approve and finalize the booking
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Booking Confirmed'),
          content: const Text('Your booking has been successfully confirmed!'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Go back to the previous screen
              },
            ),
          ],
        );
      },
    );
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

class CardDetailsBottomSheet extends StatelessWidget {
  final VoidCallback onConfirm;

  const CardDetailsBottomSheet({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color primaryColor = const Color(0xFF0A72B1);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter Card Details',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: 'Card Number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: 'Expiry Date (MM/YY)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: 'CVC',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onConfirm,
            child: const Text('Confirm Payment'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
