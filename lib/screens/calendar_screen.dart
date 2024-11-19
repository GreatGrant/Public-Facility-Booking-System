import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0A72B1);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Availability Calendar',
          style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              focusedDay: DateTime.now(),
              firstDay: DateTime(2000),
              lastDay: DateTime(2100),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              onDaySelected: (selectedDay, focusedDay) {
                // Handle date selection
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add logic for booking or showing availability details
              },
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              child: const Text('Check Availability'),
            ),
          ],
        ),
      ),
    );
  }
}
