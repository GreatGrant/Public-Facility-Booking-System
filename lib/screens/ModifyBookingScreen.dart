import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../models/booking_model.dart'; // Assuming this is the model for bookings

class ModifyBookingScreen extends StatefulWidget {
  final BookingModel booking;

  const ModifyBookingScreen({super.key, required this.booking});

  @override
  _ModifyBookingScreenState createState() => _ModifyBookingScreenState();
}

class _ModifyBookingScreenState extends State<ModifyBookingScreen> {
  late TextEditingController _numberOfPeopleController;
  late TextEditingController _facilityNameController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with current booking values
    _facilityNameController = TextEditingController(text: widget.booking.facilityName);
    _selectedDate = widget.booking.bookedAt;
    _selectedTime = TimeOfDay.fromDateTime(widget.booking.bookedAt);
  }

  @override
  void dispose() {
    _numberOfPeopleController.dispose();
    _facilityNameController.dispose();
    super.dispose();
  }

  // Function to pick the date
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Function to pick the time
  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  // Save the modified booking
  void _saveBooking() {
    final updatedBooking = BookingModel(
      id: widget.booking.id, // Assuming the ID stays the same
      facilityName: _facilityNameController.text,
      bookedAt: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      ),
      status: widget.booking.status, userId: '', // Assuming status doesn't change
    );

    // Call your method to save the updated booking (e.g., a provider method or service)
    // Example: bookingProvider.updateBooking(updatedBooking);

    // After saving, navigate back to the booking details screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Modify Booking',
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
            TextField(
              controller: _facilityNameController,
              decoration: const InputDecoration(
                labelText: 'Facility Name',
                border: OutlineInputBorder(),
              ),
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Number of People
            TextField(
              controller: _numberOfPeopleController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Number of People',
                border: OutlineInputBorder(),
              ),
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Date Picker
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.blue),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _pickDate(context),
                  child: Text(
                    'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Time Picker
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.blue),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _pickTime(context),
                  child: Text(
                    'Time: ${_selectedTime.format(context)}',
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: _saveBooking,
                child: const Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
