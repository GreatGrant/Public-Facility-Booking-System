import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/facility_model.dart';
import '../providers/facility_provider.dart';

class AddFacilityScreen extends StatefulWidget {
  const AddFacilityScreen({Key? key}) : super(key: key);

  @override
  _AddFacilityScreenState createState() => _AddFacilityScreenState();
}

class _AddFacilityScreenState extends State<AddFacilityScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String? selectedCategory;
  String? imageUrl;
  DateTime? selectedDate;
  List<DateTime> availabilityDates = [];

  final List<String> categories = [
    'Sports Center',
    'Community Hall',
    'Co-Working Space',
    'Gym',
    'Meeting Room',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final facilityProvider = Provider.of<FacilityProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Facility',
          style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0A72B1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Fill in the details below to add a new facility.",
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 15),

              // Facility Name
              _buildInputField(
                controller: nameController,
                label: "Facility Name",
                icon: Icons.business,
              ),
              const SizedBox(height: 15),

              // Facility Location
              _buildInputField(
                controller: locationController,
                label: "Facility Location",
                icon: Icons.location_on,
              ),
              const SizedBox(height: 15),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: _inputDecoration("Select Category", Icons.list),
                items: categories
                    .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedCategory = value);
                },
                validator: (value) =>
                value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 15),

              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade200,
                  ),
                  child: imageUrl == null
                      ? const Center(
                    child: Icon(Icons.add_photo_alternate_outlined, size: 50),
                  )
                      : Image.network(imageUrl!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 15),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: _inputDecoration('Facility Description', Icons.description),
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 15),

              // Availability Dates
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickAvailabilityDate,
                    icon: const Icon(Icons.date_range),
                    label: const Text("Add Date"),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      children: availabilityDates
                          .map(
                            (date) => Chip(
                          label: Text("${date.toLocal()}".split(' ')[0]),
                          onDeleted: () {
                            setState(() {
                              availabilityDates.remove(date);
                            });
                          },
                        ),
                      )
                          .toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Add Facility Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _addFacility(facilityProvider),
                  child: const Text("Add Facility"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label, icon),
      validator: (value) => value == null || value.isEmpty ? 'Enter a $label' : null,
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF0A72B1)),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
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

  Future<void> _pickAvailabilityDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && !availabilityDates.contains(pickedDate)) {
      setState(() {
        availabilityDates.add(pickedDate);
      });
    }
  }

  Future<void> _addFacility(FacilityProvider facilityProvider) async {
    if (_formKey.currentState!.validate()) {
      final facility = FacilityModel(
        id: DateTime.now().toString(), // Replace with unique ID generation logic
        name: nameController.text.trim(),
        location: locationController.text.trim(),
        category: selectedCategory!,
        description: _descriptionController.text.trim(),
        imageUrl: "",
        availabilityDates: availabilityDates,
        rating: 3.4,
        isFeatured: false,
      );
      await facilityProvider.addFacility(facility);
      Navigator.pop(context); // Return to the previous screen
    }
  }
}
