import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tmb/add_order/add_order_controller.dart';
import 'package:tmb/order_list/order_list.dart';

class AddOrderPage extends StatelessWidget {
  const AddOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddOrderController>(
    init: AddOrderController(),
    builder: (controller){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Ruta'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [

            TextField(
              controller: controller.orderIdController,
              decoration: const InputDecoration(
                labelText: 'ID'
              ),
            ),

//Campos a Llenar del formulario de nueva ruta

            const SizedBox(height: 16.0),
            TextField(
              //cambio de :TextEditingController()
              controller: controller.nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre de la Ruta',
              ),
            ),

            const SizedBox(height: 16.0),
            TextField(
              controller: controller.phoneController,
              decoration: const InputDecoration(
                labelText: 'Número de la Ruta',
              ),
            ),

            const SizedBox(height: 16.0),
            TextField(
              controller: controller.addressController,
              decoration: const InputDecoration(
                labelText: 'Destino',
              ),
            ),

            const SizedBox(height: 16.0),
            TextField(
              controller: controller.amountController,
              decoration: const InputDecoration(
                labelText: 'Tarifa',
              ),
            ),

            const SizedBox(height: 16.0),
            Container(
              height: 380,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),

              //Creación del mapa miniatura

              child: GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                initialCameraPosition: const CameraPosition(target: LatLng(0, 0), zoom: 3),
                onMapCreated: (GoogleMapController mapController) {
                  controller.mapController = mapController;
                },

                onTap: (latLong){
                  controller.selectedLocation = latLong;
                  controller.update();
                },
                markers: {
                  Marker(
                    markerId: const MarkerId('selectedLocation'),
                    position: controller.selectedLocation!,
                    infoWindow: InfoWindow(
                      title: 'Ubicación seleccionada',
                      snippet:
                        'Lat ${controller.selectedLocation!.latitude}, Lng: ${controller.selectedLocation!.longitude}',
                    ),
                  ),
              }
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                controller.addOrder(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
              child: const Text('Añadir Ruta'),
            ) //Elevated Button
          ],
        ),
      ),
    );
  });

  }
}