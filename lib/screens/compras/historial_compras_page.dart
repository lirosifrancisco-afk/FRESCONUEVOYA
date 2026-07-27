import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/compras_provider.dart';

class HistorialComprasPage extends StatelessWidget {
  const HistorialComprasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ComprasProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Compras"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: provider.compras,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Todavía no hay compras.",
              ),
            );
          }

          final compras = snapshot.data!.docs;

          return ListView.builder(
            itemCount: compras.length,
            itemBuilder: (context, index) {
              final compra = compras[index].data();

              final proveedor =
                  compra["proveedor"] ?? "";

              final total =
              (compra["total"] ?? 0).toDouble();

              Timestamp? fecha =
              compra["fecha"];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.local_shipping),
                  ),
                  title: Text(
                    proveedor,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    fecha == null
                        ? ""
                        : fecha
                        .toDate()
                        .toString()
                        .substring(0, 16),
                  ),
                  trailing: Text(
                    "\$${total.toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}