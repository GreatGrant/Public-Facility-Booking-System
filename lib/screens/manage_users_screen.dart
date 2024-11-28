import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facility_boking/global_variables.dart';
import 'package:flutter/material.dart';

import '../widgets/loading_indicator.dart';
import 'package:logger/logger.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({Key? key}) : super(key: key);

  @override
  _ManageUsersScreenState createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger logger = Logger();
  List<DocumentSnapshot> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  // Fetch users from Firestore
  Future<void> _fetchUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      setState(() {
        _users = querySnapshot.docs;
        _isLoading = false;
      });

      // Log the fetched users
      logger.i('Fetched Users: $_users');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to fetch users: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  // Delete a user from Firestore
  Future<void> _deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
      setState(() {
        _users.removeWhere((user) => user.id == userId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete user: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        backgroundColor: const Color(0xFF0A72B1), // Primary color
      ),
      body: _isLoading
          ? const Center(child: LoadingIndicator()) // Loading state
          : _users.isEmpty
          ? const Center(child: Text('No users found.'))
          : ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          var user = _users[index];
          bool isAdmin = user['role'] == 'admin'; // Check if user is admin
          return ListTile(
            title: Text(user['name'] ?? 'No name available'),
            subtitle: Text(user['email'] ?? 'No email available'),
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.person),
            ),
            trailing: isAdmin
                ? null // Don't show delete button for admins
                : IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _showDeleteDialog(user.id);
              },
            ),
            tileColor: isAdmin ? Colors.grey[300] : null, // Grey out admins
            onTap: () {
              // Navigate to User Details Screen (if needed)
            },
          );
        },
      ),
    );
  }

  // Show confirmation dialog for deletion
  void _showDeleteDialog(String userId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete User'),
        content: Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel', style: TextStyle(color: GlobalVariables.primaryColor)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteUser(userId);
            },
            child: const Text('Delete', style: TextStyle(color: GlobalVariables.primaryColor),),
          ),
        ],
      ),
    );
  }
}
