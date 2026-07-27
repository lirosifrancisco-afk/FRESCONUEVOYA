import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/carrito_provider.dart';
import '../providers/productos_provider.dart';
import '../widgets/producto_card.dart';
import 'carrito.dart';
import 'clientes.dart';
import 'productos.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String buscar = "";

  @override
  Widget build(BuildContext context) {
    final productosProvider = context.watch<ProductosProvider>();
    final carritoProvider = context.watch<CarritoProvider>();

    final productos = productosProvider.buscar(buscar);

    return Scaffold(
      appBar: AppBar(
        title: const Text("🍅 FrescoYa"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.inventory_2),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProductosPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ClientesPage(),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.shopping_cart),
        label: Text(
          "Carrito (${carritoProvider.cantidadProductos})",
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CarritoPage(),
            ),
          );
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Buscar producto...",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  buscar = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final producto = productos[index];

                return ProductoCard(
                  producto: producto,
                  onAgregar: (productoCantidad) {
                    carritoProvider.agregarProducto(productoCantidad);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(milliseconds: 800),
                        content: Text(
                          "${productoCantidad.nombre} agregado al carrito",
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}