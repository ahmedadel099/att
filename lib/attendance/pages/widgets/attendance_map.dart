import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mashariq_app/features/attendance/models/places_model.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_string.dart';

class AttendanceMap extends StatelessWidget {
  const AttendanceMap(
      {super.key, required this.userLocation, required this.places});
  final LatLng userLocation;
  final List<AttendanceLocation> places; // Assuming Place is a model class

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TSizes.sizeSmall),
      child: Container(
        height: 111.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(TSizes.sizeMedium),
          border: Border.all(
            // Add border here
            style: BorderStyle.none,
            color: Colors.grey.shade300, // Set your desired border color
            width: .0, // Set border thickness in pixels
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: TSizes.sizeSmall,
              spreadRadius: 4.0,
            ),
          ],
        ),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: userLocation,
            zoom: 17.0, // Adjust zoom level as needed
          ),
          myLocationEnabled: true,
          // Add markers and circles
          circles: {
            Circle(
              circleId: const CircleId(MTexts.CLocation),
              center: userLocation,
              radius: TSizes.sizeExtraMedium, // Adjust user location radius
              fillColor: Colors.blue.withAlpha(70),
              strokeColor: Colors.blue,
              strokeWidth: 2,
            ),
            for (var place in places)
              Circle(
                circleId: CircleId(place.id.toString()),
                center: LatLng(place.latitude ?? 0.0, place.longitude ?? 0.0),
                radius: TSizes.sizeExtraMedium,
                fillColor: Colors.orange.withAlpha(70),
                strokeColor: Colors.orange,
                strokeWidth: 2,
              ),
          },
          markers: {
            Marker(
              markerId: const MarkerId('userLocation'),
              infoWindow: const InfoWindow(title: MTexts.CLocation),
              position: userLocation,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange),
            ), // User location marker

            for (var place in places)
              Marker(
                  markerId: MarkerId(place.id.toString()),
                  position: LatLng(place.latitude ?? 0.0, place.longitude ?? 0),
                  icon: BitmapDescriptor.defaultMarker), // Place marker
          },
        ),
      ),
    );
  }
}
