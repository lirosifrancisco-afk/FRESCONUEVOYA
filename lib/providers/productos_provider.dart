import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/producto.dart';
import '../services/firestore_service.dart';

class ProductosProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<Producto> _productos = [];
  StreamSubscription<List<Producto>>? _subscription;

  bool _cargando = true;
  String? _error;

  ProductosProvider() {
    _subscription = _firestoreService.obtenerProductos().listen(
          (lista) {
        debugPrint("================================");
        debugPrint("Provider recibió ${lista.length} productos");

        for (final producto in lista) {
          debugPrint(
            "${producto.nombre} - \$${producto.precio} - Stock: ${producto.stock}",
          );
        }

        debugPrint("================================");

        _productos = lista;
        _cargando = false;
        _error = null;

        notifyListeners();
      },
      onError: (e) {
        debugPrint("ERROR EN PROVIDER: $e");

        _error = e.toString();
        _cargando = false;

        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  List<Producto> get productos => List.unmodifiable(_productos);

  bool get cargando => _cargando;

  String? get error => _error;

  List<Producto> buscar(String texto) {
    if (texto.trim().isEmpty) {
      return productos;
    }

    final busqueda = texto.toLowerCase();

    return _productos.where((producto) {
      return producto.nombre.toLowerCase().contains(busqueda) ||
          producto.categoria.toLowerCase().contains(busqueda) ||
          producto.unidad.toLowerCase().contains(busqueda);
    }).toList();
  }

  Producto? obtenerPorId(String id) {
    try {
      return _productos.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> agregarProducto({
    required String nombre,
    required double precio,
    required int stock,
    required String unidad,
    required String categoria,
    String imagen = "",
    String? unidadMedida,
    double cantidadPorUnidad = 1,
  }) async {
    await _firestoreService.agregarProducto(
      nombre: nombre,
      precio: precio,
      stock: stock,
      unidad: unidad,
      unidadMedida: unidadMedida,
      cantidadPorUnidad: cantidadPorUnidad,
      categoria: categoria,
      imagen: imagen,
    );
  }

  Future<void> editarProducto({
    required String id,
    required String nombre,
    required double precio,
    required int stock,
    required String unidad,
    required String categoria,
    String imagen = "",
    String? unidadMedida,
    double cantidadPorUnidad = 1,
  }) async {
    await _firestoreService.editarProducto(
      id: id,
      nombre: nombre,
      precio: precio,
      stock: stock,
      unidad: unidad,
      unidadMedida: unidadMedida,
      cantidadPorUnidad: cantidadPorUnidad,
      categoria: categoria,
      imagen: imagen,
    );
  }

  Future<void> eliminarProducto(String id) async {
    await _firestoreService.eliminarProducto(id);
  }

  Future<void> refrescar() async {
    notifyListeners();
  }
}