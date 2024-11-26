import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  final Color primaryColor = const Color(0xFF0A72B1); // Deep blue
  final Color accentColor = const Color(0xFFD9EEF3); // Light blue
  final Color textColor = Colors.black;

  const ProfileScreen({super.key});

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
                'Profile',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        // Check if the user is allowed to edit the profile
        bool canEditProfile = userProvider.userData?['canEditProfile'] ?? false;

        // Display user data once fetched
        return Scaffold(
          backgroundColor: accentColor,
          appBar: AppBar(
            backgroundColor: primaryColor,
            elevation: 0,
            title: const Text(
              'Profile',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Profile Image
                CircleAvatar(
                  radius: 60,
                  backgroundColor: primaryColor.withOpacity(0.2),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage: NetworkImage(
                      userProvider.userData?['profileImage'] ??
                          'https://via.placeholder.com/150', // Default if no profile image
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // User Name
                Text(
                  userProvider.userData?['name'] ?? 'Unknown User', // Display fetched name
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),

                // Email
                Text(
                  userProvider.userData?['email'] ?? 'No Email', // Display fetched email
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor.withOpacity(0.7),
                  ),
                ),

                const SizedBox(height: 30),

                // Edit Profile Button
                ElevatedButton.icon(
                  onPressed: canEditProfile
                      ? () {
                    // Navigate to Edit Profile Screen
                    Navigator.pushNamed(context, '/edit-profile');
                  }
                      : null, // Disable button if can't edit
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ), disabledForegroundColor: Colors.grey.withOpacity(0.38), disabledBackgroundColor: Colors.grey.withOpacity(0.12), // Grey color when disabled
                  ),
                ),

                const SizedBox(height: 30),

                // Account Information Section
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: Icon(Icons.person, color: primaryColor),
                    title: const Text('Account Details'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.pushNamed(context, '/account-details');
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Notifications Settings Section
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: Icon(Icons.notifications, color: primaryColor),
                    title: const Text('Notification Settings'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.pushNamed(context, '/notifications');
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // App Settings Section
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: Icon(Icons.settings, color: primaryColor),
                    title: const Text('App Settings'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.pushNamed(context, '/app-settings');
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Logout Button
                OutlinedButton.icon(
                  onPressed: () async {
                    // Handle logout logic here
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  icon: Icon(Icons.logout, color: primaryColor),
                  label: const Text('Log Out'),
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
