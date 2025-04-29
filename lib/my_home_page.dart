//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tmb/add_order/add_order.dart';
import 'package:get/get.dart';
import 'package:tmb/driver_app/driver_page.dart';
import 'order_list/order_list.dart';

class MyHomePage extends StatelessWidget{
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFF012132), // Aquí se añade el color de fondo
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50), // Altura de la barra
    child: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Track My Bus', style: TextStyle(
          color: Colors.white, // Color del texto
          fontWeight: FontWeight.bold,
          //fontFamily:
        ),
        ),
        centerTitle: true, // Para centrar el título
    shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(40), // Bordes redondeados en todos los lados
      ),
    ),
      ),
      ),


      body: Stack(
    children: [
    // Imagen de fondo
    Container(
    decoration: BoxDecoration(
    image: DecorationImage(
    image: NetworkImage('https://cdn.pixabay.com/photo/2023/02/07/18/56/rocket-7774875_1280.png'), // Reemplaza con tu URL de fondo
    fit: BoxFit.cover,
    ),
    ),
    ),



      Center(

    child: Column(

      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        SizedBox(height: 10),
        Image.network('https://cdn.pixabay.com/photo/2014/03/25/15/26/school-bus-296824_1280.png', width: 300, height: 200, ), // Reemplaza con tu URL

        //Botón para ir a la pagina de la lista de rutas
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.withOpacity(0.8), foregroundColor: Colors.white, shape: CircleBorder(), padding: EdgeInsets.all(40)),
          onPressed:() {
            //Creación de la pagina o sección del conductor
            Get.to(OrdersListPage());
          },
          child: const Text('Track',
            style: TextStyle(
            fontWeight: FontWeight.bold, // Texto en negrita
          ),),

        ),
        const SizedBox(height: 20),




        //Botón para ir a la Ruta
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow.withOpacity(0.8), foregroundColor: Colors.white, shape: CircleBorder(), padding: EdgeInsets.all(40)),
          onPressed:() {
            //Depende de get 4.6.6
            //Creación de la pagina o sección de la ruta FORMULARIO
            Get.to(const AddOrderPage());
          },
          child: const Text('Add',
    style: TextStyle(
    fontWeight: FontWeight.bold, // Texto en negrita),
    ),),
        ),
        const SizedBox(height: 20),


        //Botón para ir a la pagina del conductor
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen.withOpacity(0.8), foregroundColor: Colors.white, shape: CircleBorder(), padding: EdgeInsets.all(40)),
          onPressed:() {
            //Creación de la pagina o sección del conductor
            Get.to(DriverPage());
          },
          child: const Text('Bus',             style: TextStyle(
            fontWeight: FontWeight.bold, // Texto en negrita
            ),),
           ),
          ],
         ),
        ),
  ],
      ),
      );
  }
}
