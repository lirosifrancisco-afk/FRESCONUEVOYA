import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/pedido.dart';
import '../providers/pedidos_provider.dart';

class PedidosPage extends StatelessWidget {
  const PedidosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis pedidos"),
      ),
      body: Consumer<PedidosProvider>(
        builder: (context, provider, child) {
          if (provider.cargando) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Text(provider.error!),
            );
          }

          if (provider.pedidos.isEmpty) {
            return const Center(
              child: Text(
                "Todavía no realizaste ningún pedido.",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: provider.pedidos.length,
            itemBuilder: (context, index) {
              final Pedido pedido = provider.pedidos[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [
                          const Icon(Icons.local_shipping),
                          const SizedBox(width: 8),
                          Text(
                            "Pedido #${pedido.id.substring(0, 6)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Icon(
                            _iconoEstado(pedido.estado),
                            color: _colorEstado(pedido.estado),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            pedido.estado,
                            style: TextStyle(
                              color: _colorEstado(pedido.estado),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text(
                        DateFormat(
                          "dd/MM/yyyy HH:mm",
                        ).format(pedido.fecha),
                      ),

                      const Divider(height: 25),

                      ...pedido.productos.map(
                            (producto) => Padding(
                          padding:
                          const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(producto.nombre),
                              ),
                              Text(
                                "${producto.cantidad} ${producto.unidad}",
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Divider(height: 25),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Total: \$${pedido.total.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  static Color _colorEstado(String estado) {
    switch (estado) {
      case "Pendiente":
        return Colors.orange;

      case "Preparando":
        return Colors.blue;

      case "En camino":
        return Colors.deepOrange;

      case "Entregado":
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  static IconData _iconoEstado(String estado) {
    switch (estado) {
      case "Pendiente":
        return Icons.schedule;

      case "Preparando":
        return Icons.inventory_2;

      case "En camino":
        return Icons.local_shipping;

      case "Entregado":
        return Icons.check_circle;

      default:
        return Icons.help;
    }
  }
}