import 'package:flutter/material.dart';

import '../models/producto.dart';
import '../screens/producto_detalle_page.dart';

class ProductoCard extends StatelessWidget {
  final Producto producto;
  final Function(Producto)? onAgregar;

  const ProductoCard({
    super.key,
    required this.producto,
    this.onAgregar,
  });

  @override
  Widget build(BuildContext context) {
    Color colorStock;

    if (producto.stock <= 5) {
      colorStock = Colors.red;
    } else if (producto.stock <= 20) {
      colorStock = Colors.orange;
    } else {
      colorStock = Colors.green;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductoDetallePage(
              producto: producto,
              onAgregar: (productoCantidad) {
                if (onAgregar != null) {
                  onAgregar!(productoCantidad);
                }
              },
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: producto.imagen.isNotEmpty
                    ? Image.network(
                  producto.imagen,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      width: 90,
                      height: 90,
                      color: Colors.green.shade50,
                      child: const Icon(
                        Icons.local_grocery_store,
                        color: Colors.green,
                        size: 42,
                      ),
                    );
                  },
                )
                    : Container(
                  width: 90,
                  height: 90,
                  color: Colors.green.shade50,
                  child: const Icon(
                    Icons.local_grocery_store,
                    color: Colors.green,
                    size: 42,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      producto.nombre,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "\$ ${producto.precio.toStringAsFixed(0)}",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.inventory_2,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(producto.unidad),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 12,
                          color: colorStock,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Stock: ${producto.stock}",
                          style: TextStyle(
                            color: colorStock,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: ElevatedButton(
                  onPressed: producto.stock == 0
                      ? null
                      : () {
                    if (onAgregar != null) {
                      onAgregar!(
                        producto.copyWith(cantidad: 1),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Icon(
                    Icons.add_shopping_cart,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}