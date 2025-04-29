import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tmb/live_tracking_page/live_tracking_page.dart';
import 'package:tmb/order_list/order_list_controller.dart';

class OrdersListPage extends StatelessWidget {
  const OrdersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderListController>(
      init: OrderListController(),
        builder: (controller) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Lista de Rutas'),
          ),
          body: ListView.builder(
            itemCount: controller.orders.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('ID: ${controller.orders[index].id}'),
                subtitle: Text('Ruta: ${controller.orders[index].name}'),
                onTap: () {
                  Get.to(const LiveTrackingPage(),arguments: {'order':controller.orders[index]});
                },
              ); // ListTile
            },
          ));
    }); // ListView.builder, Scaffold
  }
}