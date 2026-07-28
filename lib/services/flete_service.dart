import 'dart:math';

class FleteService {
  // Coordenadas del local en Mendoza (punto de salida de entregas)
  static const double localLat = -32.889458;
  static const double localLng = -68.845839;

  // Tarifa configurable
  static const double costoBase = 500.0;
  static const double costoPorKm = 100.0;

  /// Calcula la distancia en kilómetros usando fórmula de Haversine.
  static double calcularDistanciaKm(double lat2, double lng2) {
    const p = 0.017453292519943295;
    final c = cos;
    final a = 0.5 -
        c((lat2 - localLat) * p) / 2 +
        c(localLat * p) * c(lat2 * p) * (1 - c((lng2 - localLng) * p)) / 2;

    final distancia = 12742 * asin(sqrt(a));
    return distancia;
  }

  /// Distancia redondeada a 2 decimales para mostrar en UI.
  static double distanciaRedondeada(double? lat, double? lng) {
    if (lat == null || lng == null) return 0;
    final distancia = calcularDistanciaKm(lat, lng);
    return (distancia * 100).roundToDouble() / 100;
  }

  /// Calcula el costo de flete.
  /// Fórmula: $500 base + $100 por km.
  static double calcularCostoFlete(double? lat, double? lng) {
    if (lat == null || lng == null) {
      return costoBase;
    }

    final distanciaKm = calcularDistanciaKm(lat, lng);
    final costo = costoBase + (distanciaKm * costoPorKm);

    return costo.roundToDouble();
  }
}
