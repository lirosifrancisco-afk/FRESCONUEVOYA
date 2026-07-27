import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/detalle_compra.dart';

class ComprasService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> guardarCompra({
    required String proveedor,
    required List<DetalleCompra> productos,
  }) async {
    final batch = _db.batch();

    final compraRef = _db.collection("compras").doc();

    double total = 0;

    for (final item in productos) {
      total += item.total;
    }

    batch.set(compraRef, {
      "proveedor": proveedor,
      "fecha": FieldValue.serverTimestamp(),
      "total": total,
      "productos": productos.map((e) => e.toMap()).toList(),
    });

    for (final item in productos) {
      final productoRef =
      _db.collection("productos").doc(item.producto.id);

      batch.update(productoRef, {
        "stock": FieldValue.increment(item.cantidad),
      });
    }

    await batch.commit();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> obtenerCompras() {
    return _db
        .collection("compras")
        .orderBy("fecha", descending: true)
        .snapshots();
  }
}