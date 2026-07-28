import 'package:cloud_firestore/cloud_firestore.dart';

class Producto {
  final String id;
  final String nombre;
  double precio;
  int cantidad;
  int stock;

  /// Campo legacy usado en gran parte de la UI.
  final String unidad;

  /// Nuevos campos para el catálogo/logística.
  final String unidadMedida; // kg, caja, unidad
  final double cantidadPorUnidad;

  final String categoria;
  final String imagen;

  final bool activo;
  final bool destacado;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    this.cantidad = 1,
    this.stock = 0,
    required this.unidad,
    String? unidadMedida,
    this.cantidadPorUnidad = 1,
    required this.categoria,
    required this.imagen,
    this.activo = true,
    this.destacado = false,
  }) : unidadMedida = unidadMedida ?? unidad;

  double get total => precio * cantidad;

  factory Producto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final unidad = (data['unidad'] ?? 'unidad').toString();

    return Producto(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      precio: (data['precio'] as num?)?.toDouble() ?? 0,
      cantidad: 1,
      stock: (data['stock'] as num?)?.toInt() ?? 0,
      unidad: unidad,
      unidadMedida: (data['unidadMedida'] ?? unidad).toString(),
      cantidadPorUnidad: (data['cantidadPorUnidad'] as num?)?.toDouble() ?? 1,
      categoria: data['categoria'] ?? '',
      imagen: data['imagen'] ?? '',
      activo: data['activo'] ?? true,
      destacado: data['destacado'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'precio': precio,
      'cantidad': cantidad,
      'stock': stock,
      'unidad': unidad,
      'unidadMedida': unidadMedida,
      'cantidadPorUnidad': cantidadPorUnidad,
      'categoria': categoria,
      'imagen': imagen,
      'activo': activo,
      'destacado': destacado,
    };
  }

  factory Producto.fromMap(Map<String, dynamic> data, String id) {
    final unidad = (data['unidad'] ?? 'unidad').toString();

    return Producto(
      id: id,
      nombre: data['nombre'] ?? '',
      precio: (data['precio'] as num?)?.toDouble() ?? 0,
      cantidad: (data['cantidad'] as num?)?.toInt() ?? 1,
      stock: (data['stock'] as num?)?.toInt() ?? 0,
      unidad: unidad,
      unidadMedida: (data['unidadMedida'] ?? unidad).toString(),
      cantidadPorUnidad: (data['cantidadPorUnidad'] as num?)?.toDouble() ?? 1,
      categoria: data['categoria'] ?? '',
      imagen: data['imagen'] ?? '',
      activo: data['activo'] ?? true,
      destacado: data['destacado'] ?? false,
    );
  }

  Producto copyWith({
    String? id,
    String? nombre,
    double? precio,
    int? cantidad,
    int? stock,
    String? unidad,
    String? unidadMedida,
    double? cantidadPorUnidad,
    String? categoria,
    String? imagen,
    bool? activo,
    bool? destacado,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      cantidad: cantidad ?? this.cantidad,
      stock: stock ?? this.stock,
      unidad: unidad ?? this.unidad,
      unidadMedida: unidadMedida ?? this.unidadMedida,
      cantidadPorUnidad: cantidadPorUnidad ?? this.cantidadPorUnidad,
      categoria: categoria ?? this.categoria,
      imagen: imagen ?? this.imagen,
      activo: activo ?? this.activo,
      destacado: destacado ?? this.destacado,
    );
  }
}
