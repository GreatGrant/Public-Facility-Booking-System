import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define your theme for the screen based on your app's global theme
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Success"),
        backgroundColor: theme.primaryColor, // Match the app bar color with the primary color of your theme
      ),
      body: Container(
        color: theme.colorScheme.surface, // Set background color to match the app's theme
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Lottie animation for payment success
              Lottie.asset('assets/success.json', width: 200, height: 200), // Add your animation file path

              // Success message
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Your payment was successful!",
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.textTheme.bodyLarge?.color, // Match text color with the theme
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
