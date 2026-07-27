import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nombreController = TextEditingController();
  final telefonoController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool ocultarPassword = true;
  bool cargando = false;

  @override
  void dispose() {
    nombreController.dispose();
    telefonoController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> registrarUsuario() async {
    if (nombreController.text.trim().isEmpty ||
        telefonoController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Completá todos los campos"),
        ),
      );
      return;
    }

    try {
      setState(() {
        cargando = true;
      });

      await _authService.registrarse(
        nombre: nombreController.text.trim(),
        telefono: telefonoController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Usuario creado correctamente"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear cuenta"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),

              const Icon(
                Icons.person_add,
                size: 90,
                color: Colors.green,
              ),

              const SizedBox(height: 20),

              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: "Nombre y apellido",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: telefonoController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Teléfono",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Correo electrónico",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: ocultarPassword,
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      ocultarPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        ocultarPassword = !ocultarPassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: cargando ? null : registrarUsuario,
                  child: cargando
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text("Crear cuenta"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}