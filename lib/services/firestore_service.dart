import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/producto.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ==========================
  // PRODUCTOS
  // ==========================

  Stream<List<Producto>> obtenerProductos() {
    return _db
        .collection("productos")
        .where("activo", isEqualTo: true)
        .orderBy("nombre")
        .snapshots()
        .map((snapshot) {
      debugPrint("==================================");
      debugPrint("Productos recibidos: ${snapshot.docs.length}");

      final productos = snapshot.docs
          .map((doc) => Producto.fromFirestore(doc))
          .toList();

      debugPrint("==================================");

      return productos;
    });
  }

  Future<void> agregarProducto({
    required String nombre,
    required double precio,
    required int stock,
    required String unidad,
    required String categoria,
    String imagen = "",
    bool activo = true,
    bool destacado = false,
  }) async {
    await _db.collection("productos").add({
      "nombre": nombre.trim(),
      "precio": precio,
      "stock": stock,
      "unidad": unidad,
      "categoria": categoria,
      "imagen": imagen,
      "activo": activo,
      "destacado": destacado,
      "fechaCreacion": FieldValue.serverTimestamp(),
      "ultimaActualizacion": FieldValue.serverTimestamp(),
    });
  }

  Future<void> editarProducto({
    required String id,
    required String nombre,
    required double precio,
    required int stock,
    required String unidad,
    required String categoria,
    String imagen = "",
    bool activo = true,
    bool destacado = false,
  }) async {
    await _db.collection("productos").doc(id).update({
      "nombre": nombre.trim(),
      "precio": precio,
      "stock": stock,
      "unidad": unidad,
      "categoria": categoria,
      "imagen": imagen,
      "activo": activo,
      "destacado": destacado,
      "ultimaActualizacion": FieldValue.serverTimestamp(),
    });
  }

  /// Desactiva el producto (no lo elimina físicamente)
  Future<void> eliminarProducto(String id) async {
    await _db.collection("productos").doc(id).update({
      "activo": false,
      "ultimaActualizacion": FieldValue.serverTimestamp(),
    });
  }

  Future<Producto?> obtenerProducto(String id) async {
    final doc = await _db.collection("productos").doc(id).get();

    if (!doc.exists) return null;

    return Producto.fromFirestore(doc);
  }

  Future<void> actualizarStock({
    required String id,
    required int nuevoStock,
  }) async {
    await _db.collection("productos").doc(id).update({
      "stock": nuevoStock,
      "ultimaActualizacion": FieldValue.serverTimestamp(),
    });
  }

  Future<void> cambiarEstadoProducto({
    required String id,
    required bool activo,
  }) async {
    await _db.collection("productos").doc(id).update({
      "activo": activo,
      "ultimaActualizacion": FieldValue.serverTimestamp(),
    });
  }

  Future<void> cambiarDestacado({
    required String id,
    required bool destacado,
  }) async {
    await _db.collection("productos").doc(id).update({
      "destacado": destacado,
      "ultimaActualizacion": FieldValue.serverTimestamp(),
    });
  }
}