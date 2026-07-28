import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

/// Servicio de integración con Mercado Pago Checkout Pro.
class MercadoPagoService {
  /// 🔑 Access Token de Mercado Pago (TEST - credenciales de prueba).
  static const String mpAccessToken =
      'TEST-7756136356459997-072719-75d14174933b98bf2751233ef66ffdd1-189971089';

  static const String _urlPreferencias =
      'https://api.mercadopago.com/checkout/preferences';

  Future<String> crearPreferencia({
    required List<Map<String, dynamic>> items,
    required String externalReference,
    required String payerEmail,
  }) async {
    if (mpAccessToken == 'TU_ACCESS_TOKEN_DE_MP_AQUI') {
      throw Exception(
        'Falta configurar el Access Token de Mercado Pago en '
        'lib/services/mercadopago_service.dart.',
      );
    }

    if (!mpAccessToken.startsWith('TEST-') &&
        !mpAccessToken.startsWith('APP_USR-')) {
      throw Exception(
        'El Access Token de Mercado Pago no tiene un formato válido.',
      );
    }

    final itemsNormalizados = items
        .where((item) => (item['unit_price'] as num?) != null)
        .map(
          (item) => {
            'title': (item['title'] ?? 'Producto').toString(),
            'quantity': (item['quantity'] as num?)?.toInt() ?? 1,
            'unit_price': ((item['unit_price'] as num?) ?? 0).toDouble(),
            'currency_id': 'ARS',
          },
        )
        .where((item) => (item['unit_price'] as double) > 0)
        .toList();

    if (itemsNormalizados.isEmpty) {
      throw Exception('No hay ítems válidos para enviar a Mercado Pago.');
    }

    final body = {
      'items': itemsNormalizados,
      'external_reference': externalReference,
      'payer': {
        'email': payerEmail.trim().isNotEmpty
            ? payerEmail.trim()
            : 'comprador@frescoya.local',
      },
      'back_urls': {
        'success': 'https://frescoya.com/pago/exito',
        'failure': 'https://frescoya.com/pago/error',
        'pending': 'https://frescoya.com/pago/pendiente',
      },
      'auto_return': 'approved',
    };

    try {
      final respuesta = await http
          .post(
            Uri.parse(_urlPreferencias),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $mpAccessToken',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 25));

      final Map<String, dynamic>? datos = _intentarParsearJson(respuesta.body);

      if (respuesta.statusCode == 200 || respuesta.statusCode == 201) {
        final initPoint = (datos?['init_point'] ?? datos?['sandbox_init_point'])
            ?.toString();

        if (initPoint == null || initPoint.isEmpty) {
          throw Exception('Mercado Pago no devolvió una URL de checkout válida.');
        }

        debugPrint('✅ Preferencia MP creada: ${datos?['id']}');
        return initPoint;
      }

      debugPrint('❌ Error MP (${respuesta.statusCode}): ${respuesta.body}');

      if (respuesta.statusCode == 401 || respuesta.statusCode == 403) {
        throw Exception(
          'Token de Mercado Pago inválido o sin permisos. Revisá tus credenciales.',
        );
      }

      final mensajeApi = _extraerMensajeMercadoPago(datos);
      if (mensajeApi != null) {
        throw Exception('Mercado Pago respondió: $mensajeApi');
      }

      throw Exception(
        'No se pudo crear la preferencia de pago '
        '(código ${respuesta.statusCode}).',
      );
    } on TimeoutException {
      throw Exception(
        'Mercado Pago tardó demasiado en responder. Intentá nuevamente.',
      );
    }
  }

  Future<void> abrirCheckout(String initPoint) async {
    final uri = Uri.parse(initPoint);

    final abierto = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!abierto) {
      throw Exception(
        'No se pudo abrir el checkout de Mercado Pago en el navegador.',
      );
    }
  }

  Map<String, dynamic>? _intentarParsearJson(String body) {
    try {
      final json = jsonDecode(body);
      if (json is Map<String, dynamic>) {
        return json;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  String? _extraerMensajeMercadoPago(Map<String, dynamic>? datos) {
    if (datos == null) return null;

    final mensaje = datos['message']?.toString();
    if (mensaje != null && mensaje.isNotEmpty) return mensaje;

    final causa = datos['cause'];
    if (causa is List && causa.isNotEmpty) {
      final primerError = causa.first;
      if (primerError is Map<String, dynamic>) {
        final descripcion = primerError['description']?.toString();
        if (descripcion != null && descripcion.isNotEmpty) return descripcion;
      }
      return causa.first.toString();
    }

    return null;
  }
}
