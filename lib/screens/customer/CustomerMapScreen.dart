import 'package:flutter/material.dart';
// import 'package:here_sdk/core.dart';
// import 'package:here_sdk/mapview.dart';

class CustomerMapScreen extends StatefulWidget {
  const CustomerMapScreen({super.key});

  @override
  State<CustomerMapScreen> createState() => _CustomerMapScreenState();
}

class _CustomerMapScreenState extends State<CustomerMapScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
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
}
