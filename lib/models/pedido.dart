import 'package:cloud_firestore/cloud_firestore.dart';

import 'producto.dart';

class Pedido {
  final String id;
  final DateTime fecha;
  final String estado;
  final double total;
  final List<Producto> productos;

  Pedido({
    required this.id,
    required this.fecha,
    required this.estado,
    required this.total,
    required this.productos,
  });

  factory Pedido.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data()!;

    final List<Producto> listaProductos =
    (data["productos"] as List<dynamic>? ?? [])
        .map((item) {
      return Producto(
        id: item["id"] ?? "",
        nombre: item["nombre"] ?? "",
        precio: (item["precio"] ?? 0).toDouble(),
        cantidad: item["cantidad"] ?? 1,
        stock: 0,
        unidad: item["unidad"] ?? "",
        categoria: item["categoria"] ?? "",
        imagen: item["imagen"] ?? "",
      );
    }).toList();

    return Pedido(
      id: doc.id,
      fecha: (data["fecha"] as Timestamp?)?.toDate() ?? DateTime.now(),
      estado: data["estado"] ?? "Pendiente",
      total: (data["total"] ?? 0).toDouble(),
      productos: listaProductos,
    );
  }
}