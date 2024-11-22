import 'package:flutter/material.dart';
import '../models/facility_model.dart';

class PaymentScreen extends StatelessWidget {
  final FacilityModel facilityModel;
  const PaymentScreen({super.key, required this.facilityModel});

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
            double padding = 16.0;
            // Adjust padding and layout based on screen width
            if (constraints.maxWidth > 600) {
              padding = 32.0; // Add more padding on larger screens
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
                        // Show loading indicator while processing payment
                        showDialog(
                          context: context,
                          barrierDismissible: false, // User cannot dismiss while loading
                          builder: (context) => const Center(child: CircularProgressIndicator()),
                        );

                        try {
                          // Simulate the payment process
                          final paymentResult = await simulatePayment();

                          // Close the loading indicator
                          Navigator.pop(context);

                          if (paymentResult['success']) {
                            // Show success message and navigate to the confirmation screen
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Payment Successful'),
                                content: Text(paymentResult['message']),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Close the dialog
                                      Navigator.pushReplacementNamed(context, '/payment-success');
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // Show error message
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Payment Failed'),
                                content: Text(paymentResult['message']),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Close the dialog
                                    },
                                    child: Text('Try Again'),
                                  ),
                                ],
                              ),
                            );
                          }
                        } catch (e) {
                          // Handle any unexpected errors
                          Navigator.pop(context); // Close the loading indicator
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Error'),
                              content: Text('An unexpected error occurred. Please try again later.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: Text('OK'),
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


