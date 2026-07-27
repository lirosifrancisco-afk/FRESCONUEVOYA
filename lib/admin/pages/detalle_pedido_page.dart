import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetallePedidoPage extends StatelessWidget {
  final String pedidoId;
  final Map<String, dynamic> pedido;

  const DetallePedidoPage({
    super.key,
    required this.pedidoId,
    required this.pedido,
  });

  Future<void> cambiarEstado(String estado) async {
    await FirebaseFirestore.instance
        .collection("pedidos")
        .doc(pedidoId)
        .update({
      "estado": estado,
    });
  }

  @override
  Widget build(BuildContext context) {
    final productos =
    (pedido["productos"] as List<dynamic>? ?? []);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle del pedido"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(
                  pedido["nombre"] ?? "Cliente",
                ),
                subtitle: Text(
                  pedido["telefono"] ?? "",
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on),
                title: Text(
                  pedido["direccion"] ?? "",
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.payment),
                title: Text(
                  pedido["metodoPago"] ?? "",
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Productos",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 10),

            ...productos.map((p) {
              return ListTile(
                title: Text(p["nombre"]),
                subtitle: Text(
                  "${p["cantidad"]} x \$${p["precio"]}",
                ),
                trailing: Text(
                  "\$${p["subtotal"]}",
                ),
              );
            }),

            const Divider(),

            ListTile(
              title: const Text(
                "TOTAL",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                "\$${pedido["total"]}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Cambiar estado",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 15),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [

                FilledButton(
                  onPressed: () async {
                    await cambiarEstado("Pendiente");
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text("Pendiente"),
                ),

                FilledButton(
                  onPressed: () async {
                    await cambiarEstado("Preparando");
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text("Preparando"),
                ),

                FilledButton(
                  onPressed: () async {
                    await cambiarEstado("En camino");
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text("En camino"),
                ),

                FilledButton(
                  onPressed: () async {
                    await cambiarEstado("Entregado");
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text("Entregado"),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}