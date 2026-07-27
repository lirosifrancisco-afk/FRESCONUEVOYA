import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/productos_provider.dart';
import '../widgets/producto_admin_card.dart';
import 'editar_producto_page.dart';
import 'nuevo_producto_page.dart';

class ProductosPage extends StatefulWidget {
  const ProductosPage({super.key});

  @override
  State<ProductosPage> createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  final TextEditingController _buscarController = TextEditingController();

  String _busqueda = "";

  @override
  void dispose() {
    _buscarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductosProvider>();
    final productos = provider.buscar(_busqueda);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Administrar Productos"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Nuevo"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NuevoProductoPage(),
            ),
          );
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: _buscarController,
              decoration: InputDecoration(
                hintText: "Buscar producto...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: _busqueda.isEmpty
                    ? null
                    : IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _buscarController.clear();
                    setState(() {
                      _busqueda = "";
                    });
                  },
                ),
              ),
              onChanged: (texto) {
                setState(() {
                  _busqueda = texto;
                });
              },
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
                style: TextStyle(fontSize: 18),
              ),
            )
                : RefreshIndicator(
              onRefresh: provider.refrescar,
              child: ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  final producto = productos[index];

                  return ProductoAdminCard(
                    producto: producto,
                    onEditar: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditarProductoPage(
                            producto: producto,
                          ),
                        ),
                      );
                    },
                    onEliminar: () async {
                      final confirmar =
                      await showDialog<bool>(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: const Text(
                                "Eliminar producto"),
                            content: Text(
                              "¿Desea eliminar ${producto.nombre}?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(
                                        context, false),
                                child:
                                const Text("Cancelar"),
                              ),
                              FilledButton(
                                onPressed: () =>
                                    Navigator.pop(
                                        context, true),
                                child:
                                const Text("Eliminar"),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmar == true) {
                        await provider
                            .eliminarProducto(producto.id);

                        if (!mounted) return;

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            content: Text(
                              "${producto.nombre} eliminado",
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}