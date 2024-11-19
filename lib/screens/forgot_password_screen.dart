import 'package:flutter/material.dart';
import '../reusable_widgets.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final Color primaryColor = const Color(0xFF0A72B1); // Deep blue
  final Color accentColor = const Color(0xFFD9EEF3); // Light blue
  final Color textColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Subtitle
                  Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Enter your email address to receive a password reset link.",
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Email Input Field
                  CustomTextField(
                    controller: _emailController,
                    labelText: "Email",
                    prefixIcon: Icons.email,
                    primaryColor: primaryColor,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email.";
                      }
                      if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                          .hasMatch(value)) {
                        return "Please enter a valid email address.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // Reset Password Button
                  CustomButton(
                    buttonText: "Send Reset Link",
                    primaryColor: primaryColor,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Handle sending reset link logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Password reset link sent to your email."),
                          ),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  // Back to Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Remembered your password?",
                        style: TextStyle(color: textColor.withOpacity(0.7)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          "Log In",
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
