import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/producto.dart';

class PedidosService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> guardarPedido({
    required List<Producto> productos,
    required double total,
    required String nombre,
    required String telefono,
    required String direccion,
    required String metodoPago,
    double? latitud,
    double? longitud,
  })async {
    final usuario = _auth.currentUser;

    if (usuario == null) {
      throw Exception("No hay un usuario autenticado.");

    }

    final pedido = {
      "nombre": nombre,
      "telefono": telefono,
      "email": usuario.email ?? "",
      "direccion": direccion,
      "latitud": latitud,
      "longitud": longitud,
      "metodoPago": metodoPago,
      "fecha": FieldValue.serverTimestamp(),
      "estado": "Pendiente",
      "total": total,
      "cantidadProductos": productos.length,
      "productos": productos
          .map(
            (p) => {
          "id": p.id,
          "nombre": p.nombre,
          "cantidad": p.cantidad,
          "precio": p.precio,
          "unidad": p.unidad,
          "categoria": p.categoria,
          "imagen": p.imagen,
          "subtotal": p.total,
        },
      )
          .toList(),
    };

    final doc = await _db.collection("pedidos").add(pedido);

    debugPrint("✅ Pedido guardado: ${doc.id}");

    return doc.id;
  }
}