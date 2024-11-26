import 'package:facility_boking/services/booking_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

import '../services/booking_service.dart';

class BookingsProvider extends ChangeNotifier{
  final BookingService _bookingService = BookingService();
  bool _isLoading = false;
  String? _error;
  int _totalBookings = 0;
  final Logger logger = Logger();

  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Map<String, dynamic>> _todaysBookings = [];

  List<Map<String, dynamic>> get todaysBookings => _todaysBookings;


  Future<void> fetchTotalFacilities() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    logger.i('Fetching total facilities count...');

    try {
      _totalBookings = await _bookingService.fetchTotalBooking();
      logger.i('Total bookings count: $_totalBookings');
    } catch (e) {
      _error = 'Failed to fetch total facilities count. Please try again.';
      logger.e('Error fetching total facilities count: $e', error: e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTodaysBookings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    logger.i('Fetching today\'s bookings...');

    try {
      _todaysBookings = await _bookingService.fetchBookingsForToday();
      logger.i('Fetched ${_todaysBookings.length} bookings for today.');
    } catch (e) {
      _error = 'Failed to fetch today\'s bookings. Please try again.';
      logger.e('Error fetching today\'s bookings: $e', error: e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}