import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsItineraryPage extends StatelessWidget {
  final double latitude;
  final double longitude;

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  MapsItineraryPage({required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    final Uri _url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude');

    String url = 'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';

    late GoogleMapController _mapController;
    Map<String, Marker> _markers = {};

    return Scaffold(
      appBar: AppBar(
        title: Text('Itinéraire'),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: 11.0
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}