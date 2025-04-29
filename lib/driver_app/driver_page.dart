import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmb/driver_app/driver_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverPage extends StatelessWidget {
  const DriverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverController>(
        init: DriverController(),
        builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('App del Conductor'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              //imagen de fondo al mostrar datos de una ruta
              Image.network(
                'https://pngimg.com/d/google_maps_pin_PNG26.png',
                width: 200,
                height: 200,
              ),


              const Text(
                'Ingresa el ID de tu Ruta:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              //getters de los datos como en el caso de anterior
              TextField(
                controller: controller.orderIdController,
                decoration: const InputDecoration (
                  hintText: 'Order ID',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),
              Visibility(
                visible: !controller.showDeliveryInfo,
                child: ElevatedButton(
                  onPressed: () async {
                    controller.getOrderById();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                  child: const Text('Enviar'),
                ), // ElevatedButton
              ), // Visibility


              const SizedBox (height: 16),
              //? Display delivery address and phone number if available
              Visibility(
                visible: controller.showDeliveryInfo,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Destino: ${controller.deliveryAddress}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ), // Text
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'No. Unidad: ${controller.phoneNumber}',
                          style: const TextStyle(fontSize: 18),
                        ), // Text

                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tarifa: \$ ${controller.amountToCollect}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox (height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            launchUrl(Uri.parse('https://www.google.com/maps?q=${controller.customerLatitude},${controller.customerLongitude}'));
                          },
                          style:
                          ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white),
                          icon: Icon(Icons.location_on),
                          label: Text('Mostrar Ubicación'),
                        ), // ElevatedButton.icon
                        ElevatedButton(
                          onPressed: () {
                            controller.startDelivery();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Iniciar Recorrido'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
