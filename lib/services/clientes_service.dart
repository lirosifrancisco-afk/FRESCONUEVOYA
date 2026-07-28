import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/cliente.dart';

class ClientesService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String _coleccion = "clientes";

  Future<void> agregarCliente(Cliente cliente) async {
    await _db.collection(_coleccion).add(cliente.toMap());
  }

  Future<void> actualizarCliente(Cliente cliente) async {
    await _db
        .collection(_coleccion)
        .doc(cliente.id)
        .update(cliente.toMap());
  }

  Future<void> eliminarCliente(String id) async {
    await _db.collection(_coleccion).doc(id).delete();
  }

  Stream<List<Cliente>> obtenerClientes() {
    return _db
        .collection(_coleccion)
        .orderBy("nombre")
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => Cliente.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList(),
    );
  }

  Future<List<Cliente>> buscarClientes(String texto) async {
    final snapshot = await _db.collection(_coleccion).get();

    final clientes = snapshot.docs
        .map(
          (doc) => Cliente.fromMap(
        doc.id,
        doc.data(),
      ),
    )
        .where(
          (cliente) => cliente.nombre
          .toLowerCase()
          .contains(texto.toLowerCase()),
    )
        .toList();

    clientes.sort(
          (a, b) => a.nombre.compareTo(b.nombre),
    );

    return clientes;
  }
}