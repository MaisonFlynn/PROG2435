import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Controller/HomeController.dart';

class MapBody extends StatelessWidget {
  final HomeController controller;

  const MapBody({
    super.key,
    required this.controller,
  });

  void _CreateMap(GoogleMapController controller) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: GoogleMap(
        onMapCreated: _CreateMap,
        initialCameraPosition:
            CameraPosition(target: controller.Location, zoom: 11.0),
        markers: {
          Marker(
            markerId: MarkerId("Location"),
            position: controller.Location,
            infoWindow: InfoWindow(title: "Location"),
          )
        },
      ),
    );
  }
}
