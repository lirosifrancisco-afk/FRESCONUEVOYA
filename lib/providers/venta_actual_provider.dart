import 'package:flutter/material.dart';

import '../models/detalle_venta.dart';
import '../models/producto.dart';
import '../services/ventas_service.dart';

enum MetodoPago {
  efectivo,
  transferencia,
  mercadoPago,
  tarjeta,
}

class VentaActualProvider extends ChangeNotifier {
  final VentasService _ventasService = VentasService();

  final List<DetalleVenta> _items = [];

  String cliente = "";

  MetodoPago metodoPago = MetodoPago.efectivo;

  String observaciones = "";

  double descuento = 0;

  List<DetalleVenta> get items => List.unmodifiable(_items);

  bool get estaVacia => _items.isEmpty;

  double get subtotal =>
      _items.fold(0.0, (total, item) => total + item.total);

  double get totalGeneral {
    final total = subtotal - descuento;
    return total < 0 ? 0 : total;
  }

  void cambiarCliente(String nombre) {
    cliente = nombre;
    notifyListeners();
  }

  void cambiarMetodoPago(MetodoPago metodo) {
    metodoPago = metodo;
    notifyListeners();
  }

  void cambiarObservaciones(String texto) {
    observaciones = texto;
    notifyListeners();
  }

  void cambiarDescuento(double valor) {
    descuento = valor;
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
    metodoPago = MetodoPago.efectivo;
    observaciones = "";
    descuento = 0;

    notifyListeners();
  }
}