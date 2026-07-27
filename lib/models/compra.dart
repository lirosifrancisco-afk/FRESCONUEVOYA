import 'detalle_compra.dart';

class Compra {
  final String id;
  final String proveedor;
  final DateTime fecha;
  final List<DetalleCompra> productos;
  final double total;

  Compra({
    required this.id,
    required this.proveedor,
    required this.fecha,
    required this.productos,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      "proveedor": proveedor,
      "fecha": fecha,
      "productos": productos.map((e) => e.toMap()).toList(),
      "total": total,
    };
  }
}