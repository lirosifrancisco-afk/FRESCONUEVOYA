import 'package:flutter/material.dart';

import '../../../models/producto.dart';

class FormularioProductoWidget extends StatelessWidget {
  final Producto producto;
  final TextEditingController cantidadController;
  final TextEditingController precioController;

  final VoidCallback onAgregar;
  final VoidCallback onCancelar;

  const FormularioProductoWidget({
    super.key,
    required this.producto,
    required this.cantidadController,
    required this.precioController,
    required this.onAgregar,
    required this.onCancelar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.green.shade100,
              child: const Icon(
                Icons.shopping_basket,
                size: 35,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              producto.nombre,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              producto.categoria,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: cantidadController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Cantidad",
                      prefixIcon: Icon(Icons.numbers),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: TextField(
                    controller: precioController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: "Precio",
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text(
                  "AGREGAR A LA VENTA",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: onAgregar,
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.close),
                label: const Text("Cancelar"),
                onPressed: onCancelar,
              ),
            ),
          ],
        ),
      ),
    );
  }
}