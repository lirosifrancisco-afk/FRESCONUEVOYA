import 'package:flutter/material.dart';

import '../productos/productos_page.dart';
import '../ventas/historial_ventas_page.dart';
import '../ventas/nueva_venta_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FrescoYa"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [

            _item(
              context,
              "Nueva Venta",
              Icons.point_of_sale,
              Colors.green,
              const NuevaVentaPage(),
            ),

            _item(
              context,
              "Productos",
              Icons.inventory,
              Colors.orange,
              const ProductosPage(),
            ),

            _item(
              context,
              "Historial",
              Icons.history,
              Colors.blue,
              const HistorialVentasPage(),
            ),

            _itemSinAccion(
              "Clientes",
              Icons.people,
              Colors.purple,
            ),

            _itemSinAccion(
              "Compras",
              Icons.shopping_cart,
              Colors.red,
            ),

            _itemSinAccion(
              "Reportes",
              Icons.bar_chart,
              Colors.teal,
            ),

            _itemSinAccion(
              "Caja",
              Icons.payments,
              Colors.indigo,
            ),

            _itemSinAccion(
              "Configuración",
              Icons.settings,
              Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(
      BuildContext context,
      String titulo,
      IconData icono,
      Color color,
      Widget pagina,
      ) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => pagina,
          ),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: color,
              child: Icon(
                icono,
                color: Colors.white,
                size: 35,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemSinAccion(
      String titulo,
      IconData icono,
      Color color,
      ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: color,
            child: Icon(
              icono,
              color: Colors.white,
              size: 35,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "Próximamente",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}