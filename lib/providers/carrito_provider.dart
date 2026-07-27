import 'package:flutter/material.dart';

import '../models/producto.dart';

class CarritoProvider extends ChangeNotifier {
  final List<Producto> _productos = [];

  List<Producto> get productos => List.unmodifiable(_productos);

  int get cantidadProductos =>
      _productos.fold(0, (total, p) => total + p.cantidad);

  double get total =>
      _productos.fold(0.0, (total, p) => total + p.total);

  bool get estaVacio => _productos.isEmpty;

  void agregarProducto(Producto producto) {
    final index = _productos.indexWhere((p) => p.id == producto.id);

    if (index >= 0) {
      final nuevaCantidad =
          _productos[index].cantidad + producto.cantidad;

      _productos[index].cantidad =
      nuevaCantidad > _productos[index].stock
          ? _productos[index].stock
          : nuevaCantidad;
    } else {
      final cantidadInicial = producto.cantidad > producto.stock
          ? producto.stock
          : producto.cantidad;

      _productos.add(
        producto.copyWith(
          cantidad: cantidadInicial,
        ),
      );
    }

    notifyListeners();
  }

  void eliminarProducto(String id) {
    _productos.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void cambiarCantidad(String id, int cantidad) {
    final index = _productos.indexWhere((p) => p.id == id);

    if (index < 0) return;

    if (cantidad <= 0) {
      _productos.removeAt(index);
    } else {
      _productos[index].cantidad =
      cantidad > _productos[index].stock
          ? _productos[index].stock
          : cantidad;
    }

    notifyListeners();
  }

  void aumentarCantidad(String id) {
    final index = _productos.indexWhere((p) => p.id == id);

    if (index < 0) return;

    if (_productos[index].cantidad < _productos[index].stock) {
      _productos[index].cantidad++;
      notifyListeners();
    }
  }

  void disminuirCantidad(String id) {
    final index = _productos.indexWhere((p) => p.id == id);

    if (index < 0) return;

    if (_productos[index].cantidad > 1) {
      _productos[index].cantidad--;
    } else {
      _productos.removeAt(index);
    }

    notifyListeners();
  }

  void vaciarCarrito() {
    _productos.clear();
    notifyListeners();
  }
}