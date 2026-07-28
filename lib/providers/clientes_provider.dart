import 'dart:async';

import 'package:flutter/material.dart';

import '../models/cliente.dart';
import '../services/clientes_service.dart';

class ClientesProvider extends ChangeNotifier {
  final ClientesService _service = ClientesService();

  List<Cliente> _clientes = [];
  List<Cliente> get clientes => _clientes;

  bool _cargando = true;
  bool get cargando => _cargando;

  StreamSubscription<List<Cliente>>? _subscription;

  ClientesProvider() {
    cargarClientes();
  }

  void cargarClientes() {
    _subscription?.cancel();

    _subscription = _service.obtenerClientes().listen((lista) {
      _clientes = lista;
      _cargando = false;
      notifyListeners();
    });
  }

  List<Cliente> buscar(String texto) {
    if (texto.trim().isEmpty) {
      return _clientes;
    }

    return _clientes.where((cliente) {
      return cliente.nombre
          .toLowerCase()
          .contains(texto.toLowerCase());
    }).toList();
  }

  Future<void> agregarCliente(Cliente cliente) async {
    await _service.agregarCliente(cliente);
  }

  Future<void> actualizarCliente(Cliente cliente) async {
    await _service.actualizarCliente(cliente);
  }

  Future<void> eliminarCliente(String id) async {
    await _service.eliminarCliente(id);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}