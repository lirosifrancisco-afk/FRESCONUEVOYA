import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'detalle_pedido_page.dart';

class PedidosPage extends StatelessWidget {
  const PedidosPage({super.key});

  Color _colorEstado(String estado) {
    switch (estado) {
      case "Pendiente":
        return Colors.orange;
      case "Preparando":
        return Colors.blue;
      case "En camino":
        return Colors.deepPurple;
      case "Entregado":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _iconoEstado(String estado) {
    switch (estado) {
      case "Pendiente":
        return Icons.schedule;
      case "Preparando":
        return Icons.restaurant;
      case "En camino":
        return Icons.delivery_dining;
      case "Entregado":
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pedidos"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("pedidos")
            .orderBy("fecha", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error al cargar los pedidos"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No hay pedidos"),
            );
          }

          final pedidos = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              final doc = pedidos[index];
              final pedido = doc.data() as Map<String, dynamic>;

              final estado = pedido["estado"] ?? "Pendiente";

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetallePedidoPage(
                          pedidoId: doc.id,
                          pedido: pedido,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                              _colorEstado(estado),
                              child: Icon(
                                _iconoEstado(estado),
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                (pedido["nombre"] ?? "")
                                    .toString()
                                    .isEmpty
                                    ? "Cliente"
                                    : pedido["nombre"],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ),
                            Chip(
                              label: Text(
                                estado,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor:
                              _colorEstado(estado),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 18,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                pedido["direccion"] ?? "",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.shopping_cart,
                              size: 18,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "${pedido["cantidadProductos"]} productos",
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment:
                          Alignment.centerRight,
                          child: Text(
                            "\$${pedido["total"]}",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight:
                              FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ],
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