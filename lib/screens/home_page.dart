import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../providers/carrito_provider.dart';
import '../providers/productos_provider.dart';

import '../widgets/producto_card.dart';
import '../widgets/home/banner_principal.dart';
import '../widgets/home/categorias.dart';

import '../admin/pages/admin_home_page.dart';
import 'carrito_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _buscarController = TextEditingController();
  String _textoBusqueda = "";

  @override
  void dispose() {
    _buscarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productosProvider = context.watch<ProductosProvider>();
    final carritoProvider = context.watch<CarritoProvider>();

    final productos = productosProvider.buscar(_textoBusqueda);

    return Scaffold(
      appBar: AppBar(
        title: const Text("🍅 FrescoYa"),
        actions: [
          IconButton(
            tooltip: "Panel de Administración",
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdminHomePage(),
                ),
              );
            },
          ),

          Stack(
            children: [
              IconButton(
                tooltip: "Carrito",
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CarritoPage(),
                    ),
                  );
                },
              ),
              if (carritoProvider.cantidadProductos > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      carritoProvider.cantidadProductos.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          IconButton(
            tooltip: "Cerrar sesión",
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          const BannerPrincipal(),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _buscarController,
              decoration: InputDecoration(
                hintText: "Buscar frutas o verduras...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: _textoBusqueda.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _buscarController.clear();

                    setState(() {
                      _textoBusqueda = "";
                    });
                  },
                )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _textoBusqueda = value;
                });
              },
            ),
          ),

          const SizedBox(height: 20),

          const Categorias(),

          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Productos disponibles",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: productos.isEmpty
                ? const Center(
              child: Text(
                "No hay productos disponibles",
              ),
            )
                : ListView.builder(
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