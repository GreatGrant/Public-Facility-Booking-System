import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/booking_model.dart';
import '../providers/user_provider.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);

    // Stream user bookings
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userBookingsStream = userProvider.streamUserBookings(userId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking History',
          style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0A72B1),
      ),
      body: StreamBuilder<List<BookingModel>>(
        stream: userBookingsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error fetching bookings: ${snapshot.error}',
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No bookings found.',
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black),
              ),
            );
          }

          final bookings = snapshot.data!;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];

              return ListTile(
                leading: const Icon(Icons.history, color: Color(0xFF0A72B1)),
                title: Text(
                  booking.facilityName,
                  style: TextStyle(color: Colors.black),
                ),
                subtitle: Text(
                  'Booked on: ${booking.bookedAt.toLocal().toString().substring(0, 10)}',
                  style: TextStyle(color: Colors.black.withOpacity(0.7)),
                ),
                trailing: const Icon(Icons.arrow_forward, color: Color(0xFF0A72B1)),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/booking-details',
                    arguments: booking,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
