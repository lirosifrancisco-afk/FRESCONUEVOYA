import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static const String _googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue: '',
  );

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late final GoogleSignIn _googleSignIn = _googleServerClientId.isNotEmpty
      ? GoogleSignIn(
          scopes: const ['email', 'profile'],
          serverClientId: _googleServerClientId,
        )
      : GoogleSignIn(scopes: const ['email', 'profile']);

  User? get usuarioActual => _auth.currentUser;

  Stream<User?> get estadoUsuario => _auth.authStateChanges();

  Future<UserCredential> iniciarSesion({
    required String email,
    required String password,
  }) async {
    try {
      final credencial = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _asegurarPerfilBase(credencial.user);
      return credencial;
    } catch (e) {
      throw Exception(obtenerMensajeError(e));
    }
  }

  Future<UserCredential> registrarse({
    required String nombre,
    required String telefono,
    required String email,
    required String password,
  }) async {
    try {
      final credencial = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore
          .collection("usuarios")
          .doc(credencial.user!.uid)
          .set({
        "uid": credencial.user!.uid,
        "nombre": nombre,
        "telefono": telefono,
        "email": email,
        "direccion": "",
        "admin": false,
        "fechaRegistro": FieldValue.serverTimestamp(),
      });

      return credencial;
    } catch (e) {
      throw Exception(obtenerMensajeError(e));
    }
  }

  /// Inicia sesión con Google y sincroniza el perfil en Firestore.
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Fuerza selector de cuenta para evitar reutilizar una sesión rota.
      await _googleSignIn.signOut();

      final GoogleSignInAccount? cuentaGoogle = await _googleSignIn.signIn();

      if (cuentaGoogle == null) {
        throw Exception("Inicio de sesión con Google cancelado por el usuario.");
      }

      final GoogleSignInAuthentication autenticacion =
          await cuentaGoogle.authentication;

      if (autenticacion.idToken == null) {
        throw Exception(
          "No se pudo obtener el token de Google. Verificá la configuración en Firebase.",
        );
      }

      final credencialFirebase = GoogleAuthProvider.credential(
        accessToken: autenticacion.accessToken,
        idToken: autenticacion.idToken,
      );

      final credencial = await _auth.signInWithCredential(credencialFirebase);

      final usuario = credencial.user;
      if (usuario == null) {
        throw Exception("No se pudo completar el inicio de sesión con Google.");
      }

      final uid = usuario.uid;
      final usuarioDoc = await _firestore.collection("usuarios").doc(uid).get();

      if (!usuarioDoc.exists) {
        await _firestore.collection("usuarios").doc(uid).set({
          "uid": uid,
          "nombre": usuario.displayName ?? "",
          "email": usuario.email ?? "",
          "foto": usuario.photoURL ?? "",
          "telefono": "",
          "direccion": "",
          "admin": false,
          "fechaRegistro": FieldValue.serverTimestamp(),
        });
      } else {
        await _firestore.collection("usuarios").doc(uid).set({
          "nombre": usuario.displayName ?? (usuarioDoc.data()?["nombre"] ?? ""),
          "email": usuario.email ?? (usuarioDoc.data()?["email"] ?? ""),
          "foto": usuario.photoURL ?? (usuarioDoc.data()?["foto"] ?? ""),
          "ultimaSesion": FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      return credencial;
    } catch (e) {
      throw Exception(obtenerMensajeError(e, paraGoogle: true));
    }
  }

  Future<void> _asegurarPerfilBase(User? user) async {
    if (user == null) return;

    final doc = await _firestore.collection("usuarios").doc(user.uid).get();
    if (!doc.exists) {
      await _firestore.collection("usuarios").doc(user.uid).set({
        "uid": user.uid,
        "nombre": user.displayName ?? "",
        "telefono": user.phoneNumber ?? "",
        "email": user.email ?? "",
        "direccion": "",
        "admin": false,
        "fechaRegistro": FieldValue.serverTimestamp(),
      });
    }
  }

  Future<bool> esAdministrador() async {
    final usuario = _auth.currentUser;

    if (usuario == null) return false;

    final doc = await _firestore.collection("usuarios").doc(usuario.uid).get();

    if (!doc.exists) return false;

    final datos = doc.data();

    return datos?["admin"] == true;
  }

  Future<void> cerrarSesion() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // Si no había sesión de Google activa no interrumpimos el logout.
    }
    await _auth.signOut();
  }

  String obtenerMensajeError(Object error, {bool paraGoogle = false}) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'El correo electrónico no tiene un formato válido.';
        case 'user-disabled':
          return 'Esta cuenta fue deshabilitada.';
        case 'user-not-found':
          return 'No existe una cuenta con ese correo.';
        case 'wrong-password':
        case 'invalid-credential':
          return 'Correo o contraseña incorrectos.';
        case 'email-already-in-use':
          return 'Ese correo ya está registrado.';
        case 'weak-password':
          return 'La contraseña es muy débil. Usá al menos 6 caracteres.';
        case 'account-exists-with-different-credential':
          return 'Ya existe una cuenta con ese correo usando otro método de ingreso.';
        case 'network-request-failed':
          return 'No hay conexión a internet. Revisá tu red e intentá nuevamente.';
        case 'too-many-requests':
          return 'Demasiados intentos. Esperá unos minutos e intentá nuevamente.';
        default:
          return error.message ?? 'Ocurrió un error de autenticación.';
      }
    }

    if (error is PlatformException && paraGoogle) {
      final codigo = error.code.toLowerCase();
      final mensaje = (error.message ?? '').toLowerCase();

      if (codigo.contains('sign_in_canceled') ||
          codigo.contains('canceled') ||
          mensaje.contains('canceled')) {
        return 'Inicio de sesión con Google cancelado.';
      }

      if (codigo.contains('network_error') || mensaje.contains('network')) {
        return 'No hay conexión a internet para iniciar con Google.';
      }

      if (mensaje.contains('10') || mensaje.contains('apiexception: 10')) {
        return 'Google Sign-In no está configurado correctamente (SHA-1/OAuth). Revisá la configuración de Firebase.';
      }

      return error.message ?? 'No se pudo iniciar sesión con Google.';
    }

    final texto = error.toString();

    if (paraGoogle &&
        (texto.contains('ApiException: 10') || texto.contains('DEVELOPER_ERROR'))) {
      return 'Google Sign-In no está configurado correctamente (SHA-1/OAuth). Revisá la configuración de Firebase.';
    }

    if (texto.startsWith('Exception: ')) {
      return texto.replaceFirst('Exception: ', '');
    }

    return 'Ocurrió un error inesperado. Intentá nuevamente.';
  }
}
