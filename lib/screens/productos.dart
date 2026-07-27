import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/productos_provider.dart';

class ProductosPage extends StatelessWidget {
  const ProductosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductosProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Productos"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _mostrarDialogo(context);
        },
      ),
      body: ListView.builder(
        itemCount: provider.productos.length,
        itemBuilder: (context, index) {
          final producto = provider.productos[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.shopping_basket),
              ),
              title: Text(producto.nombre),
              subtitle: Text(
                "${producto.unidad} - \$${producto.precio.toStringAsFixed(0)}",
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await provider.eliminarProducto(producto.id);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _mostrarDialogo(BuildContext context) {
    final nombre = TextEditingController();
    final precio = TextEditingController();
    final unidad = TextEditingController();
    final stock = TextEditingController(text: "0");

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Nuevo Producto"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombre,
                  decoration: const InputDecoration(
                    labelText: "Nombre",
                  ),
                ),
                TextField(
                  controller: precio,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Precio",
                  ),
                ),
                TextField(
                  controller: stock,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Stock",
                  ),
                ),
                TextField(
                  controller: unidad,
                  decoration: const InputDecoration(
                    labelText: "Unidad",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text("Guardar"),
              onPressed: () async {
                await context.read<ProductosProvider>().agregarProducto(
                  nombre: nombre.text,
                  precio: double.tryParse(precio.text) ?? 0,
                  stock: int.tryParse(stock.text) ?? 0,
                  unidad: unidad.text,
                  categoria: "General",
                );

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }
}