import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/producto.dart';
import '../../providers/productos_provider.dart';
import 'producto_form_page.dart';

class ProductosPage extends StatefulWidget {
  const ProductosPage({super.key});

  @override
  State<ProductosPage> createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  final TextEditingController _buscarController = TextEditingController();

  @override
  void dispose() {
    _buscarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductosProvider>();

    final List<Producto> productos =
    provider.buscar(_buscarController.text);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Productos"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ProductoFormPage(),
            ),
          );
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _buscarController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Buscar producto...",
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),

          Expanded(
            child: provider.cargando
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : productos.isEmpty
                ? const Center(
              child: Text(
                "No hay productos.",
              ),
            )
                : ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final producto = productos[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.inventory_2),
                    ),
                    title: Text(
                      producto.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Categoría: ${producto.categoria}"),
                        Text(
                            "Stock: ${producto.stock} ${producto.unidad}"),
                        Text(
                            "Precio: \$${producto.precio.toStringAsFixed(0)}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductoFormPage(
                                      producto: producto,
                                    ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            final confirmar =
                            await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text(
                                    "Eliminar producto"),
                                content: Text(
                                  "¿Eliminar ${producto.nombre}?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(
                                            context, false),
                                    child:
                                    const Text("Cancelar"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(
                                            context, true),
                                    child:
                                    const Text("Eliminar"),
                                  ),
                                ],
                              ),
                            );

                            if (confirmar == true) {
                              await provider.eliminarProducto(
                                producto.id,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}