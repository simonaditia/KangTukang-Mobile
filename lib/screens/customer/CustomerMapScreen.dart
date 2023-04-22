import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:here_sdk/core.dart';
// import 'package:here_sdk/mapview.dart';

class CustomerMapScreen extends StatefulWidget {
  const CustomerMapScreen({super.key});

  @override
  State<CustomerMapScreen> createState() => _CustomerMapScreenState();
}

class _CustomerMapScreenState extends State<CustomerMapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  List<Marker> _marker = [
    Marker(
        markerId: MarkerId(LatLng(-6.194800, 106.823078).hashCode.toString()),
        position: LatLng(-6.194800, 106.823078)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        // mapType: MapType.hybrid,
        mapType: MapType.terrain,
        markers: _marker.toSet(),
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        // onPressed: _goToTheLake,
        onPressed: () async {
          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(
              CameraUpdate.newLatLng(LatLng(-6.194800, 106.823078)));
        },
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
  // MaterialApp(
  //     home: Scaffold(body: HereMap(onMapCreated: onMapCreated)),
  //   );
  // }

  // void onMapCreated(HereMapController hereMapController) {
  //   hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
  //       (error) {
  //     if (error != null) {
  //       print("Error: " + error.toString());
  //       return;
  //     }
  //   });

  //   double distanceToEarthInMeters = 8000;
  //   hereMapController.camera.lookAtPointWithDistance(
  //       GeoCoordinates(-6.1941284, 106.8208516), distanceToEarthInMeters);
}
