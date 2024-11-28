import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facility_boking/models/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bookings_provider.dart';
import '../widgets/loading_indicator.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final Color primaryColor = const Color(0xFF0A72B1);
  // Deep blue
  final Color accentColor = const Color(0xFFD9EEF3);
  // Light blue
  final Color textColor = Colors.black;

  @override
  void initState() {
    super.initState();
    // Delay fetching of bookings until after the widget is built
    Future.microtask(() {
      Provider.of<BookingsProvider>(context, listen: false).fetchAllBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bookingsProvider = Provider.of<BookingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings',
            style: theme.textTheme.titleMedium?.copyWith(color: accentColor)
        ),
        backgroundColor: const Color(0xFF0A72B1), // Deep blue color
      ),
      body: bookingsProvider.isLoading
          ? const Center(child: LoadingIndicator())
          : bookingsProvider.error != null
          ? Center(child: Text(bookingsProvider.error!))
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: bookingsProvider.bookings.length,
        itemBuilder: (context, index) {
          final booking = bookingsProvider.bookings[index];
          return BookingCard(booking: booking);
        },
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final BookingModel booking;

  const BookingCard({required this.booking, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booking.facilityName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                PopupMenuButton<String>(
                  onSelected: (newStatus) => _updateStatus(context, newStatus),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'Pending',
                      child: Text('Pending'),
                    ),
                    const PopupMenuItem(
                      value: 'Approved',
                      child: Text('Approved'),
                    ),
                    const PopupMenuItem(
                      value: 'Cancelled',
                      child: Text('Cancelled'),
                    ),
                  ],
                  child: Chip(
                    label: Text(
                      booking.status,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: _getStatusColor(booking.status),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'User ID: ${booking.userId}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Booked At: ${_formatDate(booking.bookedAt)}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateStatus(BuildContext context, String newStatus) async {
    await Provider.of<BookingsProvider>(context, listen: false)
        .updateBookingStatus(booking.id, newStatus);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}

