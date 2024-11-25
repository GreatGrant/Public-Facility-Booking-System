import 'package:facility_boking/providers/facility_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/booking_model.dart';
import '../models/facility_model.dart';
import '../providers/user_provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final FacilityModel facilityModel;
  late DateTime selectedDate;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    facilityModel = args['facilityModel'];
    selectedDate = args['selectedDate'];
  }

  // Simulate the payment process
  Future<Map<String, dynamic>> simulatePayment() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    // Simulate a 50% chance of success or failure
    bool isSuccess = DateTime.now().second % 2 == 0;
    if (isSuccess) {
      return {'success': true, 'message': 'Payment successful'};
    } else {
      return {'success': false, 'message': 'Payment failed. Please try again.'};
    }
  }

  void _removeBookedDate() {
    final facilityProvider = Provider.of<FacilityProvider>(context, listen: false);

    // Update the facility in the provider
    facilityModel.availabilityDates.remove(selectedDate);
    facilityProvider.updateFacility(facilityModel.id, facilityModel);

    // Optionally show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking confirmed and date updated!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const Color primaryColor = Color(0xFF0A72B1);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Details',
          style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Adjust padding and layout based on screen width
            if (constraints.maxWidth > 600) {
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Payment Amount
                  Text(
                    'Total Amount',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₦${facilityModel.price}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Card Details Section
                  Text(
                    'Card Details',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Card Number',
                      prefixIcon: Icon(Icons.credit_card, color: primaryColor),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Expiry Date (MM/YY)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'CVC',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          obscureText: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Billing Address Section
                  Text(
                    'Billing Address',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Street Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Postal Code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Payment Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        // Show loading indicator while performing the payment
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(child: CircularProgressIndicator()),
                        );

                        try {
                          // Simulate payment (replace with actual payment logic)
                          final paymentResult = await simulatePayment();

                          // Check if the context is still valid before proceeding
                          if (!context.mounted) return;

                          Navigator.pop(context); // Close the loading indicator

                          if (paymentResult['success']) {
                            // Retrieve the user data from the UserProvider
                            final User? user = FirebaseAuth.instance.currentUser;

                            final userId = user?.uid;
                            if (userId == null) throw Exception('User data is missing');

                            // Create a new booking
                            final newBooking = BookingModel(
                              id: DateTime.now().toString(),
                              userId: userId,
                              facilityId: facilityModel.id,
                              status: 'Pending',
                              bookedAt: DateTime.now(),
                            );

                            // Add the booking via UserProvider
                            await context.read<UserProvider>().addBooking(newBooking);
                            _removeBookedDate(); // Remove booked date if necessary

                            // Check if the context is still valid before showing the success dialog
                            if (!context.mounted) return;

                            // Show success dialog
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Payment Successful'),
                                content: Text(paymentResult['message']),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Close the dialog
                                      Navigator.pushReplacementNamed(context, '/payment-success');
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // Payment failed, show error dialog
                            if (!context.mounted) return;

                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Payment Failed'),
                                content: Text(paymentResult['message']),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Close the dialog
                                    },
                                    child: const Text('Try Again'),
                                  ),
                                ],
                              ),
                            );
                          }
                        } catch (e, stackTrace) {
                          debugPrint('Payment Error: $e');
                          debugPrint('StackTrace: $stackTrace');

                          // Close the loading indicator
                          Navigator.pop(context);

                          // Show error dialog
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Error'),
                              content: Text('An unexpected error occurred: $e'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.payment, color: Colors.white),
                      label: const Text('Pay Now', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Cancel Button
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
            );
          },
        ),
      ),
    );
  }
}


