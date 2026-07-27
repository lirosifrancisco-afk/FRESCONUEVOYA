import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

/// Servicio de integración con Mercado Pago Checkout Pro.
///
/// Crea una "preferencia" de pago mediante la API de Mercado Pago y abre el
/// checkout en el navegador usando `url_launcher`.
///
/// IMPORTANTE: reemplazá el valor de [mpAccessToken] por tu Access Token real
/// de Mercado Pago (lo obtenés en https://www.mercadopago.com.ar/developers →
/// "Tus integraciones" → Credenciales). Usá el Access Token de PRODUCCIÓN para
/// cobrar de verdad, o el de PRUEBA (TEST) para probar el flujo sin dinero real.
class MercadoPagoService {
  /// 🔑 Access Token de Mercado Pago. REEMPLAZAR por el valor real.
  static const String mpAccessToken = 'TU_ACCESS_TOKEN_DE_MP_AQUI';

  static const String _urlPreferencias =
      'https://api.mercadopago.com/checkout/preferences';

  /// Crea una preferencia de pago en Mercado Pago y devuelve el `init_point`
  /// (URL del checkout) que hay que abrir para que el usuario pague.
  ///
  /// [items] es una lista de mapas con la forma:
  /// `{ "title": "Manzana", "quantity": 2, "unit_price": 350.0 }`
  ///
  /// [externalReference] suele ser el ID del pedido en Firestore, para poder
  /// relacionar el pago con el pedido más adelante.
  ///
  /// [payerEmail] es el email del comprador.
  Future<String> crearPreferencia({
    required List<Map<String, dynamic>> items,
    required String externalReference,
    required String payerEmail,
  }) async {
    if (mpAccessToken == 'TU_ACCESS_TOKEN_DE_MP_AQUI') {
      throw Exception(
        "Falta configurar el Access Token de Mercado Pago en "
        "lib/services/mercadopago_service.dart (constante mpAccessToken).",
      );
    }

    final body = {
      "items": items
          .map(
            (item) => {
              "title": item["title"],
              "quantity": item["quantity"],
              "unit_price": item["unit_price"],
              "currency_id": "ARS",
            },
          )
          .toList(),
      "external_reference": externalReference,
      "payer": {
        "email": payerEmail,
      },
      "back_urls": {
        "success": "https://frescoya.com/pago/exito",
        "failure": "https://frescoya.com/pago/error",
        "pending": "https://frescoya.com/pago/pendiente",
      },
      "auto_return": "approved",
    };

    final respuesta = await http.post(
      Uri.parse(_urlPreferencias),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $mpAccessToken",
      },
      body: jsonEncode(body),
    );

    if (respuesta.statusCode == 200 || respuesta.statusCode == 201) {
      final datos = jsonDecode(respuesta.body) as Map<String, dynamic>;
      final initPoint = datos["init_point"] as String?;

      if (initPoint == null || initPoint.isEmpty) {
        throw Exception(
          "Mercado Pago no devolvió un init_point válido.",
        );
      }

      debugPrint("✅ Preferencia MP creada: ${datos["id"]}");
      return initPoint;
    } else {
      debugPrint("❌ Error MP (${respuesta.statusCode}): ${respuesta.body}");
      throw Exception(
        "Error al crear la preferencia de pago (${respuesta.statusCode}).",
      );
    }
  }

  /// Abre la URL del checkout de Mercado Pago en el navegador externo.
  Future<void> abrirCheckout(String initPoint) async {
    final uri = Uri.parse(initPoint);

    final abierto = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!abierto) {
      throw Exception("No se pudo abrir el checkout de Mercado Pago.");
    }
  }
}
