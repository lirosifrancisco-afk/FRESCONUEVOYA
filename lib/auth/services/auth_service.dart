import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<void> cerrarSesion() {
    return _auth.signOut();
  }
}