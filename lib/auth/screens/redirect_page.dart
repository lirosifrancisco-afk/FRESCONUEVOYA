import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../admin/pages/admin_home_page.dart';
import '../../screens/main_navigation.dart';

class RedirectPage extends StatelessWidget {
  const RedirectPage({super.key});

  Future<bool> _esAdministrador() async {
    final usuario = FirebaseAuth.instance.currentUser;

    print("==================================");
    print("INICIANDO VERIFICACIÓN DE ADMIN");
    print("UID LOGUEADO: ${usuario?.uid}");

    if (usuario == null) {
      print("NO HAY USUARIO LOGUEADO");
      print("==================================");
      return false;
    }

    final doc = await FirebaseFirestore.instance
        .collection("usuarios")
        .doc(usuario.uid)
        .get();

    print("DOCUMENTO EXISTE: ${doc.exists}");

    if (!doc.exists) {
      print("NO EXISTE DOCUMENTO DEL USUARIO");
      print("==================================");
      return false;
    }

    final datos = doc.data();

    print("DATOS FIRESTORE:");
    print(datos);

    final admin = datos?["admin"] == true;

    print("¿ES ADMIN?: $admin");
    print("==================================");

    return admin;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _esAdministrador(),
      builder: (context, snapshot) {
        print("ESTADO FUTURE: ${snapshot.connectionState}");
        print("RESULTADO FUTURE: ${snapshot.data}");

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.data == true) {
          print("ABRIENDO PANEL ADMIN");
          return const AdminHomePage();
        }

        print("ABRIENDO APP CLIENTE");
        return const MainNavigation();
      },
    );
  }
}