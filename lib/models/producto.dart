import 'package:cloud_firestore/cloud_firestore.dart';

class Producto {
  final String id;
  final String nombre;
  double precio;
  int cantidad;
  int stock;
  final String unidad;
  final String categoria;
  final String imagen;

  /// Nuevos campos
  final bool activo;
  final bool destacado;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    this.cantidad = 1,
    this.stock = 0,
    required this.unidad,
    required this.categoria,
    required this.imagen,
    this.activo = true,
    this.destacado = false,
  });

  double get total => precio * cantidad;

  factory Producto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Producto(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      precio: (data['precio'] as num?)?.toDouble() ?? 0,
      cantidad: 1,
      stock: (data['stock'] as num?)?.toInt() ?? 0,
      unidad: data['unidad'] ?? '',
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
      'categoria': categoria,
      'imagen': imagen,
      'activo': activo,
      'destacado': destacado,
    };
  }

  factory Producto.fromMap(Map<String, dynamic> data, String id) {
    return Producto(
      id: id,
      nombre: data['nombre'] ?? '',
      precio: (data['precio'] as num?)?.toDouble() ?? 0,
      cantidad: (data['cantidad'] as num?)?.toInt() ?? 1,
      stock: (data['stock'] as num?)?.toInt() ?? 0,
      unidad: data['unidad'] ?? '',
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
      categoria: categoria ?? this.categoria,
      imagen: imagen ?? this.imagen,
      activo: activo ?? this.activo,
      destacado: destacado ?? this.destacado,
    );
  }
}