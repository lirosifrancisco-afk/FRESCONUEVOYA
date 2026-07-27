import 'producto.dart';

class ItemCarrito {
  Producto producto;
  int cantidad;

  ItemCarrito({
    required this.producto,
    this.cantidad = 1,
  });

  double get total => producto.precio * cantidad;
}