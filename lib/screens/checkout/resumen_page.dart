import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/carrito_provider.dart';
import '../../services/flete_service.dart';
import '../../services/pedidos_service.dart';
import '../../shared/theme/app_colors.dart';
import 'pedido_exitoso_page.dart';

class ResumenPage extends StatelessWidget {
  final Map<String, dynamic> datos;
  final VoidCallback onBack;

  const ResumenPage({
    super.key,
    required this.datos,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final carrito = context.watch<CarritoProvider>();

    // Calculamos el costo del flete usando las coordenadas seleccionadas en el mapa
    final double costoFlete = FleteService.calcularCostoFlete(
      datos["latitud"],
      datos["longitud"],
    );

    final double totalFinal = carrito.total + costoFlete;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Resumen del pedido",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(datos["nombre"] ?? ""),
              subtitle: Text(datos["telefono"] ?? ""),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(
                datos["tipoEntrega"] == "retiro"
                    ? "Retira en el local"
                    : (datos["direccion"] ?? ""),
              ),
              subtitle: Text(datos["referencia"] ?? ""),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.payment),
              title: Text(datos["metodoPago"] ?? ""),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Productos",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              itemCount: carrito.productos.length,
              itemBuilder: (context, index) {
                final p = carrito.productos[index];

                return ListTile(
                  title: Text(p.nombre),
                  subtitle: Text(
                    "${p.cantidad} x \$${p.precio.toStringAsFixed(0)}",
                  ),
                  trailing: Text(
                    "\$${p.total.toStringAsFixed(0)}",
                  ),
                );
              },
            ),
          ),

          const Divider(),

          // Desglose de Subtotal, Flete y Total Final
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Subtotal productos:"),
              Text("\$${carrito.total.toStringAsFixed(0)}"),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Costo de Flete (Envío):"),
              Text("\$${costoFlete.toStringAsFixed(0)}"),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "TOTAL FINAL",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Text(
                "\$${totalFinal.toStringAsFixed(0)}",
                style: const TextStyle(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Volver"),
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text("Confirmar"),
                  onPressed: () async {
                    try {
                      final id = await PedidosService().guardarPedido(
                        productos: carrito.productos,
                        total: totalFinal, // Guardamos el total real con flete incluido
                        nombre: datos["nombre"] ?? "",
                        telefono: datos["telefono"] ?? "",
                        direccion: datos["direccion"] ?? "",
                        metodoPago: datos["metodoPago"] ?? "efectivo",
                        latitud: datos["latitud"],
                        longitud: datos["longitud"],
                      );

                      carrito.vaciarCarrito();

                      if (!context.mounted) return;

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PedidoExitosoPage(
                            numeroPedido: id,
                          ),
                        ),
                      );
                    } catch (e) {
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(e.toString()),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}