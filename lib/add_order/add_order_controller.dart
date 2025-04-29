import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tmb/model/order.dart';

class AddOrderController extends GetxController {

  //id
  TextEditingController orderIdController = TextEditingController();
  //nombre del conductor
  TextEditingController nameController = TextEditingController();
  //matricula
  TextEditingController phoneController = TextEditingController();
  //sentido
  TextEditingController addressController = TextEditingController();
  //tarifa
  TextEditingController amountController = TextEditingController();

  GoogleMapController? mapController;

  LatLng currentLocation = const LatLng(0, 0);
  LatLng selectedLocation = const LatLng(0, 0);

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderColletion;

  //hilos de creacion de la colección de rutas

  @override
  Future<void> onInit() async {
    orderColletion = firestore.collection('order');
    super.onInit();
  }

  void addOrder(BuildContext context) {
    try {
      if (nameController.text.isEmpty || orderIdController.text.isEmpty || amountController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Campos incompletos')));
        return;
      } else {
        DocumentReference doc = orderColletion.doc(orderIdController.text);
        //DocumentReference doc = orderCollection.doc(orderIdController.text);
        MyOrder order = MyOrder(
          id: doc.id,
          name: nameController.text,
          latitude: selectedLocation!.latitude.toDouble(),
          longitude: selectedLocation!.longitude.toDouble(),
          phone: phoneController.text,
          address: addressController.text,
          amount: double.parse(amountController.text),
        );
        final orderJson = order.toJson();
        doc.set(orderJson);
        clearTextFields();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ruta creada con exito')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al añadir orden')));
      rethrow;
    }
  }

  //limpiamos los campos cuando se haya enviado un formulario

  clearTextFields(){
    orderIdController.clear();
    nameController.clear();
    phoneController.clear();
    addressController.clear();
    amountController.clear();
  }

}