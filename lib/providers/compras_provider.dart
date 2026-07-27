import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/compras_service.dart';

class ComprasProvider extends ChangeNotifier {
  final ComprasService _service = ComprasService();

  Stream<QuerySnapshot<Map<String, dynamic>>> get compras =>
      _service.obtenerCompras();
}