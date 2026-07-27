import 'package:flutter/material.dart';

import '../models/detalle_compra.dart';
import '../models/producto.dart';

class CompraActualProvider extends ChangeNotifier {
  final List<DetalleCompra> _productos = [];

  List<DetalleCompra> get productos => List.unmodifiable(_productos);

  double get total {
    double suma = 0;

    for (final item in _productos) {
      suma += item.total;
    }

    return suma;
  }

  bool get estaVacia => _productos.isEmpty;

  void agregarProducto({
    required Producto producto,
    required int cantidad,
    required double precioCompra,
  }) {
    final index = _productos.indexWhere(
          (e) => e.producto.id == producto.id,
    );

    if (index >= 0) {
      final existente = _productos[index];

      _productos[index] = DetalleCompra(
        producto: existente.producto,
        cantidad: existente.cantidad + cantidad,
        precioCompra: precioCompra,
      );
    } else {
      _productos.add(
        DetalleCompra(
          producto: producto,
          cantidad: cantidad,
          precioCompra: precioCompra,
        ),
      );
    }

    notifyListeners();
  }

  void eliminarProducto(int index) {
    _productos.removeAt(index);
    notifyListeners();
  }

  void limpiar() {
    _productos.clear();
    notifyListeners();
  }
}