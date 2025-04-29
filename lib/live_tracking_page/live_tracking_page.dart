import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tmb/live_tracking_page/live_tracking_controller.dart';

import 'package:tmb/model/order.dart';



class LiveTrackingPage extends StatelessWidget {
  const LiveTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arg = Get.arguments;
    MyOrder order = arg['order'];

    return GetBuilder<LiveTrackingController>(
        init: LiveTrackingController(),
        builder: (controller) {
          controller.myOrder=order;
          //Posible error con tutorial
          controller.updateCurrentLocation(order.latitude,order.longitude);
          controller.startTracking(order.id);
      return Scaffold(
        appBar: AppBar(
          title: const Text('Rastreo de Unidad'),
        ),
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              onMapCreated: (mpCtrl) {
                controller.mapController = mpCtrl;
              },
              initialCameraPosition: CameraPosition(
                target: controller.deliveryBoyLocation,
                //ZOOM
                zoom: 15,
              ),

              markers: {
                Marker(
                  markerId: const MarkerId('destino'),
                  position: controller.destination,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                  infoWindow: InfoWindow(
                    title: 'Destino',
                    snippet: 'Lat: ${controller.destination.latitude}, Lng ${controller.destination.longitude}',
                  ),
            ),
            Marker(
            markerId: const MarkerId('deliveryBoy'),
            position: controller.deliveryBoyLocation,
          icon: controller.markerIcon,
          infoWindow: InfoWindow(
          title: 'Conductor de Unidad',
          snippet: 'Lat: ${controller.deliveryBoyLocation.latitude}, Lng ${controller.deliveryBoyLocation.longitude}',
             ),
            ),
          },
          ),

            Positioned(
              top: 16.0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    "Tiempo de llegada: ${controller.remainingDistance.toStringAsFixed(2)} kilometers",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}