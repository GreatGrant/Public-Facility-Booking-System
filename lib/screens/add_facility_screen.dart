import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/facility_model.dart';
import '../providers/facility_provider.dart';

class AddFacilityScreen extends StatefulWidget {
  const AddFacilityScreen({super.key});

  @override
  _AddFacilityScreenState createState() => _AddFacilityScreenState();
}

class _AddFacilityScreenState extends State<AddFacilityScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final Color primaryColor = const Color(0xFF0A72B1);
  final Color accentColor = const Color(0xFFD9EEF3);

  DateTime? selectedDate;
  List<DateTime> availabilityDates = [];
  String? imageUrl;
  String? selectedCategory;

  final List<String> categories = [
    "Events Center",
    "Sports Center",
    "Cultural Sites",
    "Conference Hall",
    "Art Galleries",
    "Community Halls",
  ];

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Facility',
          style: theme.textTheme.titleMedium?.copyWith(color: accentColor),
        ),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                Text(
                  "Fill in the details below to add a new facility. Make sure to include all required fields like name, location, and category.",
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 15),

                // Facility Name Field
                _buildInputField(
                  controller: nameController,
                  label: "Facility Name",
                  icon: Icons.business,
                ),
                const SizedBox(height: 10),
                Text(
                  "Enter the name of the facility (e.g., City Sports Complex).",
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 15),

                // Facility Location Field
                _buildInputField(
                  controller: locationController,
                  label: "Facility Location",
                  icon: Icons.location_on,
                ),
                const SizedBox(height: 10),
                Text(
                  "Provide the address or specific location for the facility.",
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 15),

                // Category Dropdown
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: "Select Category",
                    prefixIcon: const Icon(Icons.list, color: Color(0xFF0A72B1)),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF0A72B1)),
                    ),
                  ),
                  items: categories
                      .map((category) => DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  validator: (value) => value == null ? 'Please select a category' : null,
                ),
                const SizedBox(height: 10),
                Text(
                  "Choose the type of facility from the available categories.",
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 15),

                // Image Picker
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade400),
                      color: Colors.grey.shade200,
                    ),
                    child: imageUrl == null
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined,
                              size: 50, color: Colors.grey.shade600),
                          const Text('Upload Image'),
                        ],
                      ),
                    )
                        : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  imageUrl = null;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Add an image to showcase the facility. Tap to upload or remove.",
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 15),

                // Facility Description
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Facility Description',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please provide a description';
                    }
                    return null;
                  },
                ),
                Text(
                  "Add a description for the facility.",
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 15),

                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    prefixIcon: const Icon(Icons.monetization_on, color: Color(0xFF0A72B1)),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide a price';
                    }
                    final price = double.tryParse(value);
                    if (price == null || price <= 0) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
                Text(
                  "Add a price for the facility.",
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                ),

                const SizedBox(height: 15),

                // Availability Dates
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickAvailabilityDateTime,
                      icon: const Icon(Icons.date_range),
                      label: const Text("Add Date"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A72B1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: availabilityDates
                            .map(
                              (date) => Chip(
                            label: Text(
                              DateFormat('MMMM d, yyyy \'at\' hh:mm:ss a z').format(date),
                              style: theme.textTheme.bodyMedium,
                            ),
                            deleteIcon: const Icon(Icons.close),
                            onDeleted: () {
                              setState(() {
                                availabilityDates.remove(date);
                              });
                            },
                            backgroundColor: Colors.grey.shade200,
                          ),
                        )
                            .toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Select dates when the facility is available for booking.",
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 20),

                // Add Facility Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _addFacility(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A72B1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Add Facility"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addFacility() async {
    if (_formKey.currentState!.validate()) {
      final facilityProvider = Provider.of<FacilityProvider>(context, listen: false);

      // Show loading indicator
      _showLoadingDialog();

      try {
        final facility = FacilityModel(
          id: DateTime.now().toString(),
          name: nameController.text.trim(),
          location: locationController.text.trim(),
          description: _descriptionController.text.trim(),
          category: selectedCategory ?? '',
          imageUrl: imageUrl ?? '',
          availabilityDates: availabilityDates,
          rating: 4.5,
          isFeatured: false,
          price: double.tryParse(_priceController.text.trim()) ?? 100000,
        );

        // Add the facility
        await facilityProvider.addFacility(facility);

        // Show success feedback
        Navigator.pop(context);  // Close the loading dialog
        _showSnackBar('Facility added successfully!');

        // Optionally, navigate away or reset fields
        Navigator.pop(context); // This will pop the screen
      } catch (e) {
        // Show failure feedback
        Navigator.pop(context);  // Close the loading dialog
        _showSnackBar('Failed to add facility. Please try again.');
      }
    }
  }

// Helper method to show a loading dialog
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

// Helper method to show a snackbar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }


  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageUrl = pickedFile.path;
      });
    }
  }

  Future<void> _pickAvailabilityDateTime() async {
    // Pick the date
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Pick the time
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Combine the date and time
        final pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          availabilityDates.add(pickedDateTime);
        });
      }
    }
  }


  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }
}
