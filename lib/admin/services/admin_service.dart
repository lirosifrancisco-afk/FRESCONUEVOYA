import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AdminService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<int> totalProductos() async {
    try {
      final snapshot = await _db.collection('productos').get();
      return snapshot.docs.length;
    } catch (e) {
      debugPrint("Error totalProductos: $e");
      return 0;
    }
  }

  Future<int> totalClientes() async {
    try {
      final snapshot = await _db.collection('usuarios').get();
      return snapshot.docs.length;
    } catch (e) {
      debugPrint("Error totalClientes: $e");
      return 0;
    }
  }

  Future<int> pedidosPendientes() async {
    try {
      final snapshot = await _db
          .collection('pedidos')
          .where('estado', isEqualTo: 'Pendiente')
          .get();

      return snapshot.docs.length;
    } catch (e) {
      debugPrint("Error pedidosPendientes: $e");
      return 0;
    }
  }

  Future<double> ventasTotales() async {
    try {
      final snapshot = await _db.collection('pedidos').get();

      double total = 0;

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final valor = data['total'];

        if (valor is num) {
          total += valor.toDouble();
        }
      }

      return total;
    } catch (e) {
      debugPrint("Error ventasTotales: $e");
      return 0;
    }
  }

  Future<int> productosStockBajo() async {
    try {
      final snapshot = await _db
          .collection('productos')
          .where('stock', isLessThanOrEqualTo: 5)
          .get();

      return snapshot.docs.length;
    } catch (e) {
      debugPrint("Error productosStockBajo: $e");
      return 0;
    }
  }

  Future<int> productosSinStock() async {
    try {
      final snapshot = await _db
          .collection('productos')
          .where('stock', isEqualTo: 0)
          .get();

      return snapshot.docs.length;
    } catch (e) {
      debugPrint("Error productosSinStock: $e");
      return 0;
    }
  }

  // ==========================
  // NUEVO: VENTAS POR MES
  // ==========================

  Future<List<double>> ventasPorMes() async {
    try {
      final snapshot = await _db.collection('pedidos').get();

      final meses = List<double>.filled(12, 0);

      for (final doc in snapshot.docs) {
        final data = doc.data();

        if (data["fecha"] == null) continue;
        if (data["total"] == null) continue;

        final fecha = (data["fecha"] as Timestamp).toDate();
        final total = (data["total"] as num).toDouble();

        meses[fecha.month - 1] += total;
      }

      return meses;
    } catch (e) {
      debugPrint("Error ventasPorMes: $e");
      return List<double>.filled(12, 0);
    }
  }

  // ==========================
  // NUEVO: ESTADOS PEDIDOS
  // ==========================

  Future<Map<String, int>> estadosPedidos() async {
    try {
      final snapshot = await _db.collection("pedidos").get();

      int pendientes = 0;
      int preparando = 0;
      int entregados = 0;
      int cancelados = 0;

      for (final doc in snapshot.docs) {
        final estado =
            doc.data()["estado"]?.toString().toLowerCase() ?? "";

        switch (estado) {
          case "pendiente":
            pendientes++;
            break;

          case "preparando":
            preparando++;
            break;

          case "entregado":
            entregados++;
            break;

          case "cancelado":
            cancelados++;
            break;
        }
      }

      return {
        "pendientes": pendientes,
        "preparando": preparando,
        "entregados": entregados,
        "cancelados": cancelados,
      };
    } catch (e) {
      debugPrint("Error estadosPedidos: $e");

      return {
        "pendientes": 0,
        "preparando": 0,
        "entregados": 0,
        "cancelados": 0,
      };
    }
  }Future<int> pedidosHoy() async {
    try {
      final hoy = DateTime.now();

      final inicio = DateTime(hoy.year, hoy.month, hoy.day);
      final fin = inicio.add(const Duration(days: 1));

      final snapshot = await _db
          .collection("pedidos")
          .where(
        "fecha",
        isGreaterThanOrEqualTo: Timestamp.fromDate(inicio),
      )
          .where(
        "fecha",
        isLessThan: Timestamp.fromDate(fin),
      )
          .get();

      return snapshot.docs.length;
    } catch (e) {
      debugPrint("Error pedidosHoy: $e");
      return 0;
    }
  }

  Future<double> ventasHoy() async {
    try {
      final hoy = DateTime.now();

      final inicio = DateTime(hoy.year, hoy.month, hoy.day);
      final fin = inicio.add(const Duration(days: 1));

      final snapshot = await _db
          .collection("pedidos")
          .where(
        "fecha",
        isGreaterThanOrEqualTo: Timestamp.fromDate(inicio),
      )
          .where(
        "fecha",
        isLessThan: Timestamp.fromDate(fin),
      )
          .get();

      double total = 0;

      for (final doc in snapshot.docs) {
        final data = doc.data();

        if (data["total"] is num) {
          total += (data["total"] as num).toDouble();
        }
      }

      return total;
    } catch (e) {
      debugPrint("Error ventasHoy: $e");
      return 0;
    }
  }

  Future<double> ticketPromedio() async {
    try {
      final snapshot = await _db.collection("pedidos").get();

      if (snapshot.docs.isEmpty) return 0;

      double total = 0;

      for (final doc in snapshot.docs) {
        final data = doc.data();

        if (data["total"] is num) {
          total += (data["total"] as num).toDouble();
        }
      }

      return total / snapshot.docs.length;
    } catch (e) {
      debugPrint("Error ticketPromedio: $e");
      return 0;
    }
  }
}