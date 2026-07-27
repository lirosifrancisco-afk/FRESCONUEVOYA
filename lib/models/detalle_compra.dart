import 'producto.dart';

class DetalleCompra {
  final Producto producto;
  final int cantidad;
  final double precioCompra;

  DetalleCompra({
    required this.producto,
    required this.cantidad,
    required this.precioCompra,
  });

  double get total => cantidad * precioCompra;

  Map<String, dynamic> toMap() {
    return {
      "productoId": producto.id,
      "nombre": producto.nombre,
      "cantidad": cantidad,
      "precioCompra": precioCompra,
      "total": total,
    };
  }

  factory DetalleCompra.fromMap(Map<String, dynamic> map) {
    throw UnimplementedError(
      "Se implementará cuando hagamos el historial de compras.",
    );
  }
}