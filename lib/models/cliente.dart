class Cliente {
  final String id;
  final String nombre;
  final String telefono;
  final String direccion;
  final bool activo;

  Cliente({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.direccion,
    this.activo = true,
  });

  Map<String, dynamic> toMap() {
    return {
      "nombre": nombre,
      "telefono": telefono,
      "direccion": direccion,
      "activo": activo,
    };
  }

  factory Cliente.fromFirestore(
      String id,
      Map<String, dynamic> data,
      ) {
    return Cliente(
      id: id,
      nombre: data["nombre"] ?? "",
      telefono: data["telefono"] ?? "",
      direccion: data["direccion"] ?? "",
      activo: data["activo"] ?? true,
    );
  }
}