import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/facility_model.dart';

class FacilityCard extends StatelessWidget {
  final FacilityModel facility;
  final VoidCallback onTap;

  const FacilityCard({
    super.key,
    required this.facility,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the number of full stars, half stars, and empty stars based on rating
    int fullStars = facility.rating.floor();
    int halfStars = (facility.rating - fullStars >= 0.5) ? 1 : 0;
    int emptyStars = 5 - fullStars - halfStars;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: SizedBox(
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: facility.imageUrl,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  facility.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,  // Truncate the name if it's too long
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    // Full stars
                    for (int i = 0; i < fullStars; i++)
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                    // Half star (optional)
                    if (halfStars > 0)
                      const Icon(Icons.star_half, color: Colors.amber, size: 16),
                    // Empty stars
                    for (int i = 0; i < emptyStars; i++)
                      const Icon(Icons.star_border, color: Colors.amber, size: 16),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Details',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
