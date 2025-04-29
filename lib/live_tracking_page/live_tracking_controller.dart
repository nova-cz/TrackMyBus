import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:tmb/model/order.dart';


class LiveTrackingController extends GetxController {

  //definición de variables
  MyOrder? myOrder;
  String orderId = '0000';

  //Ruta destino comun
  //LatLng destination = const LatLng(10.2929726, 76.1645936);
  LatLng destination = const LatLng(19.003771338451806, -98.19493769844019);


  //Ubicación de la terminal central del transporte universitario
  LatLng deliveryBoyLocation = const LatLng(18.9968564236888, -98.1954172289464);



  GoogleMapController? mapController;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
  double remainingDistance = 0.0;
  final Location location = Location();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderTrackingCollection;


  //base de datos
  @override
  void onInit() {
    orderTrackingCollection = firestore.collection('orderTracking');
    addCustomMarker();
    super.onInit();
  }


  // PIN de seguimiento
  void addCustomMarker() {
    ImageConfiguration configuration = const ImageConfiguration(
        size: Size(0, 0), devicePixelRatio: 1);

    BitmapDescriptor.fromAssetImage(
        configuration, 'assets/marker.ico').then((value) {
      markerIcon = value;
    });
  }


  // actualizacion de la ubicacion actual
  void updateCurrentLocation(double latitude, double longitude){
    destination = LatLng(latitude, longitude);
    update();
  }


  //procedimiento para iniciar el rastreo de una ruta
  void startTracking(String orderId) {
    try {
      orderTrackingCollection.doc(orderId).snapshots().listen((snapshot) {
        if (snapshot.exists) {
          var trackingData = snapshot.data() as Map<String, dynamic>;
          double latitude = trackingData['latitude'];
          double longitude = trackingData['longitude'];
          updateUIWithLocation(latitude, longitude);
          print('Ultima ubicación: $latitude, $longitude');
        } else {
          print('Sin datos de rastreo disponibles para la ruta: $orderId');
        }
      });
    } catch (e) {
      rethrow;
    }
  }

//actualizamos la interfaz del mapa, la camara
  void updateUIWithLocation(double latitude, double longitude) {
    deliveryBoyLocation = LatLng(latitude, longitude);
    // Update the camera position to the new location
    mapController?.animateCamera(CameraUpdate.newLatLng(deliveryBoyLocation));
    calculateRemainingDistance();
  }

  //funcion para calcular la distancia restante en kilometros, de aqui, pueden
  //implementar la funcion de tiempo haciendo una conversión
  void calculateRemainingDistance() {
    double distance = Geolocator.distanceBetween(
        deliveryBoyLocation.latitude,
        deliveryBoyLocation.longitude,
        destination.latitude,
        destination.longitude,
    );
    // Convert distance from meters to kilometers
    double distanceInKm = distance / 1000;
    remainingDistance = distanceInKm;
    print("Distancia Restante: $distanceInKm Kilometros");
    update();
  }


}