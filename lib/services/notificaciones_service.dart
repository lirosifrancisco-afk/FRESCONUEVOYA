import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Handler para mensajes recibidos cuando la app está en segundo plano o
/// cerrada. Debe ser una función de nivel superior (top-level) y estar
/// anotada con @pragma para que sobreviva al tree-shaking en release.
@pragma('vm:entry-point')
Future<void> manejarMensajeEnSegundoPlano(RemoteMessage mensaje) async {
  // Firebase ya está inicializado en main.dart. Aquí solo dejamos registro.
  debugPrint("🔔 Notificación en segundo plano: ${mensaje.messageId}");
}

/// Servicio encargado de las notificaciones push (Firebase Cloud Messaging)
/// y de mostrar notificaciones locales cuando la app está en primer plano.
class NotificacionesService {
  static final NotificacionesService _instancia =
      NotificacionesService._interno();

  factory NotificacionesService() => _instancia;

  NotificacionesService._interno();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _canalAndroid =
      AndroidNotificationChannel(
    'frescoya_canal_pedidos',
    'Notificaciones de pedidos',
    description: 'Avisos sobre el estado de tus pedidos en FrescoYa',
    importance: Importance.high,
  );

  /// Inicializa FCM y las notificaciones locales:
  /// - Pide permisos de notificaciones al usuario.
  /// - Configura el canal de Android y el plugin de notificaciones locales.
  /// - Obtiene el token FCM y lo guarda en el documento del usuario.
  /// - Escucha mensajes en primer plano y los muestra localmente.
  Future<void> inicializar() async {
    try {
      // 1. Pedimos permiso de notificaciones (obligatorio en Android 13+ e iOS).
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // 2. Inicializamos flutter_local_notifications.
      await _inicializarNotificacionesLocales();

      // 3. Guardamos el token FCM en Firestore para poder enviar avisos.
      final token = await _messaging.getToken();
      if (token != null) {
        await _guardarToken(token);
      }

      // Si el token se refresca, lo volvemos a guardar.
      _messaging.onTokenRefresh.listen(_guardarToken);

      // 4. Mensajes recibidos mientras la app está en primer plano.
      FirebaseMessaging.onMessage.listen((RemoteMessage mensaje) {
        final notificacion = mensaje.notification;
        if (notificacion != null) {
          mostrarNotificacionLocal(
            notificacion.title ?? "FrescoYa",
            notificacion.body ?? "",
          );
        }
      });
    } catch (e) {
      debugPrint("⚠️ Error al inicializar notificaciones: $e");
    }
  }

  Future<void> _inicializarNotificacionesLocales() async {
    const configAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const configIOS = DarwinInitializationSettings();

    const config = InitializationSettings(
      android: configAndroid,
      iOS: configIOS,
    );

    await _localNotifications.initialize(config);

    // Creamos el canal de notificaciones en Android.
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_canalAndroid);
  }

  /// Guarda el token FCM en el documento del usuario autenticado.
  Future<void> _guardarToken(String token) async {
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario == null) return;

    await FirebaseFirestore.instance
        .collection("usuarios")
        .doc(usuario.uid)
        .set({"fcmToken": token}, SetOptions(merge: true));

    debugPrint("✅ Token FCM guardado para ${usuario.uid}");
  }

  /// Muestra una notificación local en el dispositivo.
  static Future<void> mostrarNotificacionLocal(
    String title,
    String body,
  ) async {
    final plugin = FlutterLocalNotificationsPlugin();

    const detalleAndroid = AndroidNotificationDetails(
      'frescoya_canal_pedidos',
      'Notificaciones de pedidos',
      channelDescription:
          'Avisos sobre el estado de tus pedidos en FrescoYa',
      importance: Importance.high,
      priority: Priority.high,
    );

    const detalleIOS = DarwinNotificationDetails();

    const detalle = NotificationDetails(
      android: detalleAndroid,
      iOS: detalleIOS,
    );

    await plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      detalle,
    );
  }
}
