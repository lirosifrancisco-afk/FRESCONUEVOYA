import 'package:flutter/material.dart';

import '../../models/producto.dart';

class ProductoAdminCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const ProductoAdminCard({
    super.key,
    required this.producto,
    required this.onEditar,
    required this.onEliminar,
  });

  Color _colorStock() {
    if (producto.stock <= 0) {
      return Colors.red;
    }

    if (producto.stock <= 10) {
      return Colors.orange;
    }

    return Colors.green;
  }

  String _textoStock() {
    if (producto.stock <= 0) {
      return "SIN STOCK";
    }

    if (producto.stock <= 10) {
      return "STOCK BAJO";
    }

    return "EN STOCK";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade200,
              ),
              child: producto.imagen.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  producto.imagen,
                  fit: BoxFit.cover,
                ),
              )
                  : const Icon(
                Icons.image,
                size: 40,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    producto.categoria,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "\$${producto.precio.toStringAsFixed(2)} / ${producto.cantidadPorUnidad} ${producto.unidadMedida}",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Chip(
                    backgroundColor: _colorStock().withOpacity(.15),
                    label: Text(
                      "${_textoStock()} (${producto.stock})",
                      style: TextStyle(
                        color: _colorStock(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: Colors.blue,
                  onPressed: onEditar,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: onEliminar,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}