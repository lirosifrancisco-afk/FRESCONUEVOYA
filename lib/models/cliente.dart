class Cliente {
  final String id;
  final String nombre;
  final String telefono;
  final String direccion;
  final String observaciones;
  final double saldo;

  Cliente({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.direccion,
    required this.observaciones,
    required this.saldo,
  });

  factory Cliente.fromMap(String id, Map<String, dynamic> map) {
    return Cliente(
      id: id,
      nombre: map['nombre'] ?? '',
      telefono: map['telefono'] ?? '',
      direccion: map['direccion'] ?? '',
      observaciones: map['observaciones'] ?? '',
      saldo: (map['saldo'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'telefono': telefono,
      'direccion': direccion,
      'observaciones': observaciones,
      'saldo': saldo,
    };
  }
}