import 'package:flutter/material.dart';

import '../models/cliente.dart';

class ClientesProvider extends ChangeNotifier {
  final List<Cliente> _clientes = [
    Cliente(
      id: "1",
      nombre: "Consumidor Final",
      telefono: "",
      direccion: "",
    ),
  ];

  bool get cargando => false;

  List<Cliente> get clientes => List.unmodifiable(_clientes);

  List<Cliente> buscar(String texto) {
    if (texto.trim().isEmpty) return clientes;

    return clientes.where((c) {
      return c.nombre.toLowerCase().contains(texto.toLowerCase()) ||
          c.telefono.toLowerCase().contains(texto.toLowerCase());
    }).toList();
  }

  Future<void> agregarCliente({
    required String nombre,
    required String telefono,
    required String direccion,
  }) async {
    _clientes.add(
      Cliente(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: nombre,
        telefono: telefono,
        direccion: direccion,
      ),
    );

    notifyListeners();
  }

  Future<void> editarCliente(Cliente cliente) async {
    final index = _clientes.indexWhere((c) => c.id == cliente.id);

    if (index != -1) {
      _clientes[index] = cliente;
      notifyListeners();
    }
  }

  Future<void> eliminarCliente(String id) async {
    _clientes.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  Cliente? obtenerPorId(String id) {
    try {
      return _clientes.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}