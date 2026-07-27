import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/pedido.dart';

class PedidosProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Pedido> _pedidos = [];

  bool _cargando = true;
  String? _error;

  List<Pedido> get pedidos => _pedidos;
  bool get cargando => _cargando;
  String? get error => _error;

  PedidosProvider() {
    cargarPedidos();
  }

  void cargarPedidos() {
    final usuario = _auth.currentUser;

    if (usuario == null) {
      _cargando = false;
      notifyListeners();
      return;
    }

    _db
        .collection("pedidos")
        .where("uidUsuario", isEqualTo: usuario.uid)
        .orderBy("fecha", descending: true)
        .snapshots()
        .listen(
          (snapshot) {
        _pedidos = snapshot.docs
            .map(
              (doc) => Pedido.fromFirestore(doc),
        )
            .toList();

        _cargando = false;
        _error = null;

        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _cargando = false;
        notifyListeners();
      },
    );
  }

  void limpiar() {
    _pedidos = [];
    notifyListeners();
  }
}