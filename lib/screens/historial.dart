import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ventas_provider.dart';

class HistorialPage extends StatelessWidget {
  const HistorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ventas = context.watch<VentasProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de ventas"),
      ),
      body: ventas.ventas.isEmpty
          ? const Center(
        child: Text("Todavía no hay ventas."),
      )
          : ListView.builder(
        itemCount: ventas.ventas.length,
        itemBuilder: (context, index) {
          final venta = ventas.ventas[index];

          return ListTile(
            leading: const Icon(Icons.receipt_long),
            title: Text(
                "\$${venta.total.toStringAsFixed(0)}"),
            subtitle: Text(
              venta.fecha.toString(),
            ),
          );
        },
      ),
    );
  }
}