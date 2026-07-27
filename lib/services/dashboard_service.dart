import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<int> obtenerCantidadProductos() async {
    final snapshot = await _db.collection('productos').get();
    return snapshot.docs.length;
  }

  Future<int> obtenerCantidadClientes() async {
    final snapshot = await _db.collection('usuarios').get();
    return snapshot.docs.length;
  }

  Future<int> obtenerCantidadPedidos() async {
    final snapshot = await _db.collection('pedidos').get();
    return snapshot.docs.length;
  }

  Future<double> obtenerVentasTotales() async {
    final snapshot = await _db.collection('pedidos').get();

    double total = 0;

    for (final doc in snapshot.docs) {
      total += (doc.data()['total'] as num?)?.toDouble() ?? 0;
    }

    return total;
  }
}