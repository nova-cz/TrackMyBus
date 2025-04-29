
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:tmb/model/order.dart';
//HOLAAAAAAAAAAA
class DriverController extends GetxController {


  TextEditingController orderIdController = TextEditingController();

  final Location location = Location();

  String deliveryAddress = '';
  String phoneNumber = '';
  String amountToCollect = '0';
  //ubicación por defecto del mapa en nuestro caso la estación STU
  double customerLatitude = 37.7749;
  double customerLongitude = -122.4194;

  bool showDeliveryInfo = false;
  bool isDeliveryStarted = false;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final CollectionReference orderCollection;
  late final CollectionReference orderTrackingCollection;

  @override
  void onInit() {
    super.onInit();
    orderCollection = firestore.collection('order');
    orderTrackingCollection = firestore.collection('orderTracking');
    getLocationPermission();
  }

  //procedimiento para devolver la información de una Ruta

  getOrderById() async {
    try {
      String orderId = orderIdController.text;
      QuerySnapshot querySnapshot = await orderCollection.where(
          'id', isEqualTo: orderId).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        MyOrder? order = MyOrder.fromJson(data);
        if (order != null) {
          deliveryAddress = order.address ?? '';
          phoneNumber = order.phone ?? '';
          amountToCollect = order.amount.toString();
          customerLatitude = order.latitude ?? 0;
          customerLongitude = order.longitude ?? 0;
          showDeliveryInfo = true;
        }
        update();
      } else {
        Get.snackbar('Error', 'Ruta no encontrada');
        return null;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      rethrow;
    }
  }

//Solicitud de permiso de uso de ubicación
  Future<void> getLocationPermission() async {
    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }
      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

//iniciar recorrido
  void startDelivery() {
    location.onLocationChanged.listen((LocationData currentLocation) {
      print('Location changed: ${currentLocation.latitude}, ${currentLocation
          .longitude}');
      //? Update order tracking location when location changes
      saveOrUpdateMyOrderLocation(
          orderIdController.text, currentLocation.latitude ?? 0,
          currentLocation.longitude ?? 0);
    });
    location.enableBackgroundMode(enable: true);
  }


  //almacenado o creacion de la ubicación actual
  Future <void> saveOrUpdateMyOrderLocation(String orderId, double latitude,
      double longitude) async {
    try {
      final DocumentReference docRef = orderTrackingCollection.doc(orderId);

      //? Use a transaction to ensure atomic read and write
      await firestore.runTransaction((transaction) async {
        final DocumentSnapshot snapshot = await transaction.get(docRef);

        if (snapshot.exists) {
          //? Document exists, so we update it
          transaction.update(docRef, {
            'latitude': latitude,
            'longitude': longitude,
          });
        } else {
          //? Document does not exist, we create a new one
          transaction.set(docRef, {
            'orderId': orderId,
            'latitude': latitude,
            'longitude': longitude,
          });
        }
      });
    } catch (e) {
      print('Error saving or updating order location: $e');
    }
  }
}