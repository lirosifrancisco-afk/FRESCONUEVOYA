import 'package:flutter/material.dart';

import '../models/detalle_venta.dart';
import '../models/producto.dart';
import '../services/ventas_service.dart';

class VentaActualProvider extends ChangeNotifier {
  final VentasService _ventasService = VentasService();

  final List<DetalleVenta> _items = [];

  String cliente = "";

  List<DetalleVenta> get items => List.unmodifiable(_items);

  bool get estaVacia => _items.isEmpty;

  double get totalGeneral =>
      _items.fold(0.0, (total, item) => total + item.total);

  void cambiarCliente(String nombre) {
    cliente = nombre;
    notifyListeners();
  }

  void agregarProducto({
    required Producto producto,
    required int cantidad,
    required double precio,
  }) {
    _items.add(
      DetalleVenta(
        producto: producto,
        cantidad: cantidad,
        precio: precio,
      ),
    );

    notifyListeners();
  }

  void eliminarProducto(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void actualizarCantidad(int index, int cantidad) {
    _items[index].cantidad = cantidad;
    notifyListeners();
  }

  void actualizarPrecio(int index, double precio) {
    _items[index].precio = precio;
    notifyListeners();
  }

  Future<void> guardarVenta() async {
    if (_items.isEmpty) return;

    await _ventasService.guardarVenta(
      cliente: cliente,
      productos: _items,
      total: totalGeneral,
    );

    limpiarVenta();
  }

  void limpiarVenta() {
    _items.clear();
    cliente = "";
    notifyListeners();
  }
}