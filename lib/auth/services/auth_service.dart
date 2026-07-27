import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get usuarioActual => _auth.currentUser;

  Stream<User?> get estadoUsuario => _auth.authStateChanges();

  Future<UserCredential> iniciarSesion({
    required String email,
    required String password,
  }) async {
    final credencial = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credencial.user!.uid;

    final usuarioDoc =
    await _firestore.collection("usuarios").doc(uid).get();

    if (!usuarioDoc.exists) {
      await _firestore.collection("usuarios").doc(uid).set({
        "uid": uid,
        "nombre": "",
        "telefono": "",
        "email": credencial.user!.email ?? "",
        "direccion": "",
        "admin": false,
        "fechaRegistro": FieldValue.serverTimestamp(),
      });
    }

    return credencial;
  }

  Future<UserCredential> registrarse({
    required String nombre,
    required String telefono,
    required String email,
    required String password,
  }) async {
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
  }

  /// Inicia sesión con la cuenta de Google del dispositivo.
  ///
  /// Obtiene las credenciales de Google, las convierte en una credencial de
  /// Firebase y crea/actualiza el documento del usuario en la colección
  /// "usuarios" de Firestore. Retorna el [UserCredential] resultante.
  Future<UserCredential> signInWithGoogle() async {
    // Abrimos el selector de cuentas de Google.
    final GoogleSignInAccount? cuentaGoogle = await _googleSignIn.signIn();

    // El usuario canceló el flujo de selección de cuenta.
    if (cuentaGoogle == null) {
      throw Exception("Inicio de sesión con Google cancelado.");
    }

    final GoogleSignInAuthentication autenticacion =
        await cuentaGoogle.authentication;

    // Convertimos las credenciales de Google en una credencial de Firebase.
    final credencialFirebase = GoogleAuthProvider.credential(
      accessToken: autenticacion.accessToken,
      idToken: autenticacion.idToken,
    );

    final credencial = await _auth.signInWithCredential(credencialFirebase);

    final usuario = credencial.user!;
    final uid = usuario.uid;

    final usuarioDoc =
        await _firestore.collection("usuarios").doc(uid).get();

    if (!usuarioDoc.exists) {
      // Primer ingreso con Google: creamos el documento del usuario.
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
      // Usuario existente: actualizamos datos básicos que pueden cambiar.
      await _firestore.collection("usuarios").doc(uid).set({
        "nombre": usuario.displayName ??
            (usuarioDoc.data()?["nombre"] ?? ""),
        "email": usuario.email ?? (usuarioDoc.data()?["email"] ?? ""),
        "foto": usuario.photoURL ?? (usuarioDoc.data()?["foto"] ?? ""),
      }, SetOptions(merge: true));
    }

    return credencial;
  }

  Future<bool> esAdministrador() async {
    final usuario = _auth.currentUser;

    if (usuario == null) return false;

    final doc = await _firestore
        .collection("usuarios")
        .doc(usuario.uid)
        .get();

    if (!doc.exists) return false;

    final datos = doc.data();

    return datos?["admin"] == true;
  }

  Future<void> cerrarSesion() async {
    // Cerramos también la sesión de Google si el usuario ingresó con ella.
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // Ignoramos errores si no había sesión de Google activa.
    }
    await _auth.signOut();
  }
}