import 'package:flutter/material.dart';

import '../reusable_widgets.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Define a consistent color scheme
  final Color primaryColor = const Color(0xFF0A72B1); // Deep blue
  final Color accentColor = const Color(0xFFD9EEF3); // Light blue
  final Color textColor = Colors.black;

  LoginScreen({super.key});

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
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Log in to manage your bookings and facilities.",
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Reusable CustomTextField for email
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
                  const SizedBox(height: 20),

                  // Reusable CustomTextField for password
                  CustomTextField(
                    controller: _passwordController,
                    labelText: "Password",
                    prefixIcon: Icons.lock,
                    primaryColor: primaryColor,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password.";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters long.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // Reusable CustomButton for login
                  CustomButton(
                    buttonText: "Log In",
                    primaryColor: primaryColor,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Handle login logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Logging in...')),
                        );
                        Navigator.pushNamed(context, '/home-screen');
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  // Signup Redirect
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(color: textColor.withOpacity(0.7)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup'); // Adjust as needed
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgot-password');
                        },
                        child: Text(
                          "Forgot Password?",
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
