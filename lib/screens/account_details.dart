import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../widgets/loading_indicator.dart';

class AccountDetailsScreen extends StatelessWidget {

  const AccountDetailsScreen({super.key});
  final Color primaryColor = const Color(0xFF0A72B1); // Deep blue
  final Color accentColor = const Color(0xFFD9EEF3); // Light blue
  final Color textColor = Colors.black;
  final bool isEditable = false; // This flag controls whether the user can edit

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.userData == null) {
          // Show loading indicator while fetching data
          return Scaffold(
            backgroundColor: accentColor,
            appBar: AppBar(
              backgroundColor: primaryColor,
              title: Text(
                'Account Details',
                style: theme.textTheme.titleMedium?.copyWith(color: accentColor),
              ),
              centerTitle: true,
            ),
            body: const Center(child: LoadingIndicator()),
          );
        }

        // Display user data once fetched
        return Scaffold(
          backgroundColor: accentColor,
          appBar: AppBar(
            backgroundColor: primaryColor,
            title:  Text(
              'Account Details',
              style: theme.textTheme.titleMedium?.copyWith(color: accentColor),
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
                      color: isEditable ? primaryColor : Colors.grey, // Disable edit icon
                    ),
                    onTap: isEditable
                        ? () {
                      // Handle phone number edit
                      Navigator.pushNamed(context, '/edit-phone');
                    }
                        : null, // Disable tap when not editable
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
                      color: isEditable ? primaryColor : Colors.grey, // Disable edit icon
                    ),
                    onTap: isEditable
                        ? () {
                      // Handle address edit
                      Navigator.pushNamed(context, '/edit-address');
                    }
                        : null, // Disable tap when not editable
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
                      color: isEditable ? primaryColor : Colors.grey, // Disable icon
                    ),
                    onTap: isEditable
                        ? () {
                      // Navigate to Change Password screen
                      Navigator.pushNamed(context, '/change-password');
                    }
                        : null, // Disable tap when not editable
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
                      color: isEditable ? primaryColor : Colors.grey, // Disable icon
                    ),
                    onTap: isEditable
                        ? () {
                      // Navigate to Security Settings screen
                      Navigator.pushNamed(context, '/security-settings');
                    }
                        : null, // Disable tap when not editable
                  ),
                ),

                const SizedBox(height: 20),

                // Delete Account Button
                OutlinedButton.icon(
                  onPressed: isEditable
                      ? () {
                    // Handle account deletion logic here
                    Navigator.pushReplacementNamed(context, '/delete-account');
                  }
                      : null, // Disable button when not editable
                  icon: const Icon(Icons.delete, color: Colors.grey),
                  label: const Text('Delete Account'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isEditable ? null : Colors.grey, side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ), // Grey out the button
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
