import 'producto.dart';

class DetalleVenta {
  final Producto producto;
  int cantidad;
  double precio;

  DetalleVenta({
    required this.producto,
    required this.cantidad,
    required this.precio,
  });

  double get total => cantidad * precio;

  Map<String, dynamic> toMap() {
    return {
      "productoId": producto.id,
      "nombre": producto.nombre,
      "cantidad": cantidad,
      "precio": precio,
      "total": total,
      "unidad": producto.unidad,
      "categoria": producto.categoria,
    };
  }
}