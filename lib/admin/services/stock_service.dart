import 'package:cloud_firestore/cloud_firestore.dart';

class StockService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> entregarPedido({
    required String pedidoId,
    required Map<String, dynamic> pedido,
  }) async {
    await _db.runTransaction((transaction) async {
      final pedidoRef = _db.collection("pedidos").doc(pedidoId);

      final pedidoSnap = await transaction.get(pedidoRef);

      if (!pedidoSnap.exists) {
        throw Exception("El pedido no existe.");
      }

      final datosPedido = pedidoSnap.data()!;

      // Si ya fue entregado y ya descontó stock, no hacemos nada
      if (datosPedido["stockDescontado"] == true &&
          datosPedido["estado"] == "Entregado") {
        return;
      }

      final productos = List<Map<String, dynamic>>.from(
        datosPedido["productos"] ?? [],
      );

      for (final item in productos) {
        final productoRef = _db
            .collection("productos")
            .doc(item["id"]);

        final productoSnap = await transaction.get(productoRef);

        if (!productoSnap.exists) {
          throw Exception(
            "No existe el producto ${item["nombre"]}",
          );
        }

        final dataProducto = productoSnap.data()!;

        final stockActual =
            (dataProducto["stock"] as num?)?.toInt() ?? 0;

        final cantidad =
            (item["cantidad"] as num?)?.toInt() ?? 0;

        if (stockActual < cantidad) {
          throw Exception(
            "Stock insuficiente para ${item["nombre"]}",
          );
        }

        transaction.update(productoRef, {
          "stock": stockActual - cantidad,
        });
      }

      transaction.update(pedidoRef, {
        "estado": "Entregado",
        "stockDescontado": true,
        "fechaEntrega": FieldValue.serverTimestamp(),
      });
    });
  }
}