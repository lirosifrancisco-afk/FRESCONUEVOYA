import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/screens/auth_gate.dart';
import '../auth/services/auth_service.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final nombreController = TextEditingController();
  final telefonoController = TextEditingController();
  final direccionController = TextEditingController();

  String _email = "";
  bool _cargando = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  @override
  void dispose() {
    nombreController.dispose();
    telefonoController.dispose();
    direccionController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      setState(() => _cargando = false);
      return;
    }

    _email = usuario.email ?? "";

    try {
      final doc =
          await _firestore.collection("usuarios").doc(usuario.uid).get();

      final datos = doc.data() ?? {};

      nombreController.text = datos["nombre"] ?? (usuario.displayName ?? "");
      telefonoController.text = datos["telefono"] ?? "";
      direccionController.text = datos["direccion"] ?? "";
      if ((_email).isEmpty) {
        _email = datos["email"] ?? "";
      }
    } catch (_) {
      // Si falla la carga dejamos los campos vacíos.
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
      }
    }
  }

  Future<void> _guardarCambios() async {
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario == null) return;

    try {
      setState(() => _guardando = true);

      await _firestore.collection("usuarios").doc(usuario.uid).set({
        "nombre": nombreController.text.trim(),
        "telefono": telefonoController.text.trim(),
        "direccion": direccionController.text.trim(),
      }, SetOptions(merge: true));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Datos actualizados"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al guardar: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _guardando = false);
      }
    }
  }

  Future<void> _cerrarSesion() async {
    await _authService.cerrarSesion();

    if (!mounted) return;

    // Volvemos al AuthGate, que mostrará la pantalla de login.
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthGate()),
      (route) => false,
    );
  }

  String get _inicial {
    final nombre = nombreController.text.trim();
    if (nombre.isNotEmpty) return nombre[0].toUpperCase();
    if (_email.isNotEmpty) return _email[0].toUpperCase();
    return "?";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi Perfil"),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.green,
                      child: Text(
                        _inicial,
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Center(
                    child: Text(
                      _email,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  TextField(
                    controller: nombreController,
                    decoration: const InputDecoration(
                      labelText: "Nombre y apellido",
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: telefonoController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Teléfono",
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: direccionController,
                    decoration: const InputDecoration(
                      labelText: "Dirección",
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),

                  const SizedBox(height: 30),

                  ElevatedButton.icon(
                    icon: _guardando
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save),
                    label: const Text("Guardar cambios"),
                    onPressed: _guardando ? null : _guardarCambios,
                  ),

                  const SizedBox(height: 15),

                  OutlinedButton.icon(
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text(
                      "Cerrar sesión",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: _cerrarSesion,
                  ),
                ],
              ),
            ),
    );
  }
}
