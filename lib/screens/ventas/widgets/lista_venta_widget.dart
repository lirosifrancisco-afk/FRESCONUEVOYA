import 'package:flutter/material.dart';

import '../../../providers/venta_actual_provider.dart';

class ListaVentaWidget extends StatelessWidget {
  final VentaActualProvider venta;

  const ListaVentaWidget({
    super.key,
    required this.venta,
  });

  @override
  Widget build(BuildContext context) {
    if (venta.items.isEmpty) {
      return const Center(
        child: Text(
          "Todavía no agregaste productos",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: venta.items.length,
      itemBuilder: (context, index) {
        final item = venta.items[index];

        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 5,
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green.shade100,
              child: Text(
                item.cantidad.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            title: Text(
              item.producto.nombre,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Precio: \$${item.precio.toStringAsFixed(0)}",
                ),
                Text(
                  "Total: \$${item.total.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            trailing: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              tooltip: "Eliminar",
              onPressed: () {
                venta.eliminarProducto(index);
              },
            ),
          ),
        );
      },
    );
  }
}