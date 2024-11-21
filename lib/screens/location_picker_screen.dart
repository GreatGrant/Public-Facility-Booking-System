// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class LocationPickerScreen extends StatefulWidget {
//   final LatLng initialPosition;
//
//   const LocationPickerScreen({Key? key, required this.initialPosition})
//       : super(key: key);
//
//   @override
//   _LocationPickerScreenState createState() => _LocationPickerScreenState();
// }
//
// class _LocationPickerScreenState extends State<LocationPickerScreen> {
//   LatLng? _selectedLocation;
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedLocation = widget.initialPosition;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Pick a Location")),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: widget.initialPosition,
//           zoom: 14,
//         ),
//         onTap: (position) {
//           setState(() {
//             _selectedLocation = position;
//           });
//         },
//         markers: _selectedLocation != null
//             ? {
//           Marker(
//             markerId: const MarkerId('selectedLocation'),
//             position: _selectedLocation!,
//           )
//         }
//             : {},
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.check),
//         onPressed: () {
//           Navigator.pop(context, _selectedLocation);
//         },
//       ),
//     );
//   }
// }
