import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/carrito_provider.dart';
import '../shared/theme/app_colors.dart';
import '../shared/theme/app_text_styles.dart';
import '../shared/widgets/app_button.dart';
import 'checkout/checkout_page.dart';

class CarritoPage extends StatelessWidget {
  const CarritoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final carrito = context.watch<CarritoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mi Carrito",
          style: AppTextStyles.subtitulo.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      body: carrito.estaVacio
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 90,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              "Tu carrito está vacío",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: carrito.productos.length,
              itemBuilder: (context, index) {
                final producto = carrito.productos[index];

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: producto.imagen.isNotEmpty
                              ? Image.network(
                            producto.imagen,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _imagenVacia(),
                          )
                              : _imagenVacia(),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                producto.nombre,
                                style: AppTextStyles.subtitulo,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "\$${producto.precio.toStringAsFixed(0)}",
                                style: AppTextStyles.precio,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Subtotal: \$${producto.total.toStringAsFixed(0)}",
                                style: AppTextStyles.descripcion,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      carrito.disminuirCantidad(
                                        producto.id,
                                      );
                                    },
                                  ),
                                  Text(
                                    producto.cantidad.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_circle,
                                      color: Colors.green,
                                    ),
                                    onPressed: producto.cantidad >=
                                        producto.stock
                                        ? null
                                        : () {
                                      carrito.aumentarCantidad(
                                        producto.id,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            carrito.eliminarProducto(
                              producto.id,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black12,
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "TOTAL",
                        style: AppTextStyles.titulo,
                      ),
                      Text(
                        "\$${carrito.total.toStringAsFixed(0)}",
                        style: AppTextStyles.precio.copyWith(
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    texto: "Finalizar compra",
                    icono: Icons.shopping_bag,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CheckoutPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      icon: const Icon(
                        Icons.delete_outline,
                      ),
                      label: const Text(
                        "Vaciar carrito",
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.danger,
                        side: const BorderSide(
                          color: AppColors.danger,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: carrito.vaciarCarrito,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagenVacia() {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.local_grocery_store,
        color: AppColors.primary,
        size: 42,
      ),
    );
  }
}