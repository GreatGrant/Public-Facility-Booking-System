import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class AccountDetailsScreen extends StatelessWidget {
  final Color primaryColor = const Color(0xFF0A72B1); // Deep blue
  final Color accentColor = const Color(0xFFD9EEF3); // Light blue
  final Color textColor = Colors.black;

  const AccountDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.userData == null) {
          // Show loading indicator while fetching data
          return Scaffold(
            backgroundColor: accentColor,
            appBar: AppBar(
              backgroundColor: primaryColor,
              elevation: 0,
              title: const Text(
                'Account Details',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Display user data once fetched
        return Scaffold(
          backgroundColor: accentColor,
          appBar: AppBar(
            backgroundColor: primaryColor,
            elevation: 0,
            title: const Text(
              'Account Details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // User Name
                Text(
                  userProvider.userData?['name'] ?? 'Unknown User',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),

                const SizedBox(height: 10),

                // User Email
                Text(
                  userProvider.userData?['email'] ?? 'No Email',
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor.withOpacity(0.7),
                  ),
                ),

                const SizedBox(height: 30),

                // Phone Number
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: Icon(Icons.phone, color: primaryColor),
                    title: Text(
                      userProvider.userData?['phoneNumber'] ?? 'No Phone',
                      style: TextStyle(color: textColor),
                    ),
                    trailing: Icon(
                      Icons.edit,
                      color: primaryColor,
                    ),
                    onTap: () {
                      // Handle phone number edit
                      Navigator.pushNamed(context, '/edit-phone');
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Address
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: Icon(Icons.home, color: primaryColor),
                    title: Text(
                      userProvider.userData?['address'] ?? 'No Address',
                      style: TextStyle(color: textColor),
                    ),
                    trailing: Icon(
                      Icons.edit,
                      color: primaryColor,
                    ),
                    onTap: () {
                      // Handle address edit
                      Navigator.pushNamed(context, '/edit-address');
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Change Password
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: Icon(Icons.lock, color: primaryColor),
                    title: const Text('Change Password'),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: primaryColor,
                    ),
                    onTap: () {
                      // Navigate to Change Password screen
                      Navigator.pushNamed(context, '/change-password');
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Security Settings
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: Icon(Icons.security, color: primaryColor),
                    title: const Text('Security Settings'),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: primaryColor,
                    ),
                    onTap: () {
                      // Navigate to Security Settings screen
                      Navigator.pushNamed(context, '/security-settings');
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Delete Account Button
                OutlinedButton.icon(
                  onPressed: () {
                    // Handle account deletion logic here
                    Navigator.pushReplacementNamed(context, '/delete-account');
                  },
                  icon: Icon(Icons.delete, color: primaryColor),
                  label: const Text('Delete Account'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
