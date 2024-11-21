import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';  // Import Provider to access AuthProvider
import '../reusable_widgets.dart';
import '../providers/auth_provider.dart';  // Import your AuthProvider

class SignupScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  final Color primaryColor = const Color(0xFF0A72B1);
  final Color accentColor = const Color(0xFFD9EEF3);
  final Color textColor = Colors.black;

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access AuthProvider using Provider
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: accentColor,
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create an Account",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Sign up to access facilities and manage your bookings.",
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Name field
                      CustomTextField(
                        controller: _nameController,
                        labelText: "Full Name",
                        prefixIcon: Icons.person,
                        primaryColor: primaryColor,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your name.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Email field
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

                      // Mobile number field
                      CustomTextField(
                        controller: _mobileController,
                        labelText: "Mobile Number",
                        prefixIcon: Icons.phone,
                        primaryColor: primaryColor,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your mobile number.";
                          }
                          if (!RegExp(r"^[0-9]{10,13}$").hasMatch(value)) {
                            return "Please enter a valid phone number.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Password field
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
                      const SizedBox(height: 20),

                      // Confirm password field
                      CustomTextField(
                        controller: _confirmPasswordController,
                        labelText: "Confirm Password",
                        prefixIcon: Icons.lock,
                        primaryColor: primaryColor,
                        obscureText: true,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return "Passwords do not match.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),

                      // Sign Up Button
                      CustomButton(
                        buttonText: "Sign Up",
                        primaryColor: primaryColor,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // Call sign up method from AuthProvider
                            await authProvider.signUp(
                              _emailController.text,
                              _passwordController.text,
                              _nameController.text,
                              context,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),

                      // Login redirect
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
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

                      // Display error message if present
                      if (authProvider.errorMessage!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            authProvider.errorMessage!,
                            style: const TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Show loading animation while the provider is loading
              if (authProvider.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Lottie.asset(
                      'assets/loading_animation.json',
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
