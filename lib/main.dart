import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

// AUTH
import 'auth/screens/auth_gate.dart';

// SERVICIOS
import 'services/notificaciones_service.dart';

// PROVIDERS
import 'providers/carrito_provider.dart';
import 'providers/categorias_provider.dart';
import 'providers/clientes_provider.dart';
import 'providers/compra_actual_provider.dart';
import 'providers/compras_provider.dart';
import 'providers/pedidos_provider.dart';
import 'providers/productos_provider.dart';
import 'providers/venta_actual_provider.dart';
import 'providers/ventas_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Registramos el handler de notificaciones en segundo plano (FCM).
  FirebaseMessaging.onBackgroundMessage(manejarMensajeEnSegundoPlano);

  // Inicializamos las notificaciones push (permisos, token, foreground).
  await NotificacionesService().inicializar();

  runApp(const FrescoYaApp());
}

class FrescoYaApp extends StatelessWidget {
  const FrescoYaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductosProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoriasProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ClientesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CarritoProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PedidosProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) {
            final provider = VentasProvider();
            provider.iniciar();
            return provider;
          },
        ),

        ChangeNotifierProvider(
          create: (_) => VentaActualProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => CompraActualProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => ComprasProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FrescoYa',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.green,
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),

          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),

          floatingActionButtonTheme:
          const FloatingActionButtonThemeData(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
          ),

          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          cardTheme: CardThemeData(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),

        // Pantalla principal: el AuthGate decide si mostrar login,
        // la app del cliente o el panel de administración.
        home: const AuthGate(),
      ),
    );
  }
}
