import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/detalle_venta.dart';
import '../models/venta.dart';

class VentasService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Guarda una venta y descuenta el stock
  Future<void> guardarVenta({
    required String cliente,
    required List<DetalleVenta> productos,
    required double total,
  }) async {
    final batch = _db.batch();

    final ventaRef = _db.collection("ventas").doc();

    batch.set(ventaRef, {
      "cliente": cliente,
      "fecha": FieldValue.serverTimestamp(),
      "total": total,
      "productos": productos.map((e) => e.toMap()).toList(),
    });

    for (final item in productos) {
      final productoRef =
      _db.collection("productos").doc(item.producto.id);

      batch.update(productoRef, {
        "stock": FieldValue.increment(-item.cantidad),
      });
    }

    await batch.commit();
  }

  /// Obtiene todas las ventas ordenadas por fecha
  Stream<List<Venta>> obtenerVentas() {
    return _db
        .collection("ventas")
        .orderBy("fecha", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => Venta.fromFirestore(doc))
          .toList(),
    );
  }
}