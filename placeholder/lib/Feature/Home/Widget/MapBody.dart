import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Controller/HomeController.dart';

class MapBody extends StatelessWidget {
  final HomeController controller;

  MapBody({
    super.key,
    required this.controller,
  });

  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text("Map Screen"),
          Container(
              width: 768,
              height: 768,
              decoration: BoxDecoration(
                color: Colors.black12,
                border: Border.all(width: 2, color: Colors.black),
                borderRadius: BorderRadius.circular(6),
              ),
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition:
                    CameraPosition(target: controller.latlng, zoom: 11.0),
                markers: {
                  Marker(
                      markerId: MarkerId("UserLocation"),
                      position: controller.latlng,
                      infoWindow: InfoWindow(title: "Your Location"))
                },
              ))
        ],
      ),
    );
  }
}
