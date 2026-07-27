import 'dart:async';

import 'package:flutter/material.dart';

import '../models/venta.dart';
import '../services/ventas_service.dart';

class VentasProvider extends ChangeNotifier {
  final VentasService _service = VentasService();

  List<Venta> _ventas = [];

  StreamSubscription<List<Venta>>? _subscription;

  List<Venta> get ventas => _ventas;

  double get totalDelDia {
    final hoy = DateTime.now();

    return _ventas
        .where((v) =>
    v.fecha.year == hoy.year &&
        v.fecha.month == hoy.month &&
        v.fecha.day == hoy.day)
        .fold(0.0, (total, venta) => total + venta.total);
  }

  void iniciar() {
    _subscription?.cancel();

    _subscription = _service.obtenerVentas().listen((lista) {
      _ventas = lista;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}