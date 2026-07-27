import 'dart:math';

class FleteService {
  // Coordenadas de tu local o depósito central en el Gran Mendoza (ej: Centro de Mendoza)
  static const double localLat = -32.889458;
  static const double localLng = -68.845839;

  // Calcula la distancia en kilómetros usando la fórmula de Haversine
  static double calcularDistancia(double lat2, double lng2) {
    const p = 0.017453292519943295; // Math.pi / 180
    final c = cos;
    final a = 0.5 -
        c((lat2 - localLat) * p) / 2 +
        c(localLat * p) * c(lat2 * p) * (1 - c((lng2 - localLng) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  // Calcula el costo del flete según los kilómetros de distancia
  static double calcularCostoFlete(double? lat, double? lng) {
    if (lat == null || lng == null) return 1500.0; // Flete base por defecto si no eligió mapa

    double distanciaKm = calcularDistancia(lat, lng);

    // Ejemplo de tarifa para el Gran Mendoza:
    // Flete base de $1000 hasta 3 km, y luego un adicional por km extra
    double costoBase = 1000.0;
    double costoPorKm = 300.0;

    double fleteTotal = costoBase + (distanciaKm * costoPorKm);

    // Establecemos un flete mínimo
    if (fleteTotal < 1200) return 1200.0;

    return fleteTotal.roundToDouble();
  }
}