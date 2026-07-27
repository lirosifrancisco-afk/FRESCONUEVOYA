import 'package:cloud_firestore/cloud_firestore.dart';

import 'detalle_venta.dart';

class Venta {
  final String id;
  final DateTime fecha;
  final String cliente;
  final List<DetalleVenta> productos;
  final double total;

  Venta({
    required this.id,
    required this.fecha,
    required this.cliente,
    required this.productos,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      "fecha": Timestamp.fromDate(fecha),
      "cliente": cliente,
      "total": total,
      "productos": productos.map((e) => e.toMap()).toList(),
    };
  }

  factory Venta.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data()!;

    return Venta(
      id: doc.id,
      fecha: (data["fecha"] as Timestamp).toDate(),
      cliente: data["cliente"] ?? "",
      total: (data["total"] as num).toDouble(),
      productos: const [],
    );
  }
}