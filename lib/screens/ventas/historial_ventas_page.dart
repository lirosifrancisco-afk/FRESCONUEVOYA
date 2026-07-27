import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/ventas_provider.dart';

class HistorialVentasPage extends StatelessWidget {
  const HistorialVentasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VentasProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Ventas"),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.green.shade100,
            child: Column(
              children: [
                const Text(
                  "TOTAL VENDIDO HOY",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "\$${provider.totalDelDia.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: provider.ventas.isEmpty
                ? const Center(
              child: Text(
                "Todavía no hay ventas.",
              ),
            )
                : ListView.builder(
              itemCount: provider.ventas.length,
              itemBuilder: (context, index) {
                final venta = provider.ventas[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.receipt_long),
                    ),
                    title: Text(
                      venta.cliente.isEmpty
                          ? "Mostrador"
                          : venta.cliente,
                    ),
                    subtitle: Text(
                      DateFormat(
                        "dd/MM/yyyy HH:mm",
                      ).format(venta.fecha),
                    ),
                    trailing: Text(
                      "\$${venta.total.toStringAsFixed(0)}",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
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