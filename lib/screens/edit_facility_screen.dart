import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/facility_model.dart';
import '../providers/facility_provider.dart';
import '../widgets/loading_indicator.dart';

class EditFacilityScreen extends StatefulWidget {
  final FacilityModel facility;

  const EditFacilityScreen({required this.facility});

  @override
  _EditFacilityScreenState createState() => _EditFacilityScreenState();
}

class _EditFacilityScreenState extends State<EditFacilityScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController(); // New price controller
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
  void initState() {
    super.initState();

    // Initialize the controllers with the current facility data
    nameController.text = widget.facility.name;
    locationController.text = widget.facility.location;
    _descriptionController.text = widget.facility.description;
    _priceController.text = widget.facility.price.toString();
    selectedCategory = widget.facility.category;
    imageUrl = widget.facility.imageUrl;
    availabilityDates = List<DateTime>.from(widget.facility.availabilityDates);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Facility',
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
                // Facility Name Field
                _buildInputField(
                  controller: nameController,
                  label: "Facility Name",
                  icon: Icons.business,
                ),
                const SizedBox(height: 10),

                // Facility Location Field
                _buildInputField(
                  controller: locationController,
                  label: "Facility Location",
                  icon: Icons.location_on,
                ),
                const SizedBox(height: 10),

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
                const SizedBox(height: 15),

                // Price Field
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '₦',
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0xFF0A72B1),
                        ),
                      ),
                    ),
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

                // Update Facility Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _updateFacility(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A72B1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Update Facility"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateFacility() async {
    if (_formKey.currentState!.validate()) {
      final facilityProvider = Provider.of<FacilityProvider>(context, listen: false);

      // Show loading indicator
      _showLoadingDialog();

      try {
        final updatedFacility = widget.facility.copyWith(
          name: nameController.text.trim(),
          location: locationController.text.trim(),
          description: _descriptionController.text.trim(),
          category: selectedCategory ?? '',
          imageUrl: imageUrl ?? '',
          availabilityDates: availabilityDates,
          price: double.tryParse(_priceController.text.trim()) ?? 0, // Updated price
        );

        // Update the facility
        await facilityProvider.updateFacility(updatedFacility);

        // Show success feedback
        Navigator.pop(context);  // Close the loading dialog
        _showSnackBar('Facility updated successfully!');

        // Optionally, navigate away or reset fields
        Navigator.pop(context); // This will pop the screen
      } catch (e) {
        // Show failure feedback
        Navigator.pop(context);  // Close the loading dialog
        _showSnackBar('Failed to update facility');
      }
    }
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
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        availabilityDates.add(pickedDate);
      });
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: LoadingIndicator(),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please provide a $label';
        }
        return null;
      },
    );
  }
}
