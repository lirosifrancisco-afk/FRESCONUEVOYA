import 'package:flutter/material.dart';

import '../../../models/producto.dart';

class BuscadorProductosWidget extends StatelessWidget {
  final TextEditingController controller;
  final List<Producto> productos;
  final Function(Producto producto) onSeleccionar;

  const BuscadorProductosWidget({
    super.key,
    required this.controller,
    required this.productos,
    required this.onSeleccionar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Buscar producto...",
              prefixIcon: const Icon(Icons.search),
              suffixIcon: controller.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  controller.clear();
                  FocusScope.of(context).unfocus();
                },
              )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),

        Expanded(
          child: productos.isEmpty
              ? const Center(
            child: Text(
              "No se encontraron productos",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          )
              : ListView.separated(
            itemCount: productos.length,
            separatorBuilder: (_, __) =>
            const Divider(height: 1),
            itemBuilder: (context, index) {
              final producto = productos[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.shade100,
                  child: const Icon(
                    Icons.shopping_basket,
                    color: Colors.green,
                  ),
                ),
                title: Text(
                  producto.nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "${producto.categoria} • Stock: ${producto.stock}",
                ),
                trailing: Text(
                  "\$${producto.precio.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 16,
                  ),
                ),
                onTap: () => onSeleccionar(producto),
              );
            },
          ),
        ),
      ],
    );
  }
}