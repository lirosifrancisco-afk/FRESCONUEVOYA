import 'package:flutter/material.dart';

import '../admin/admin_navigation.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi Perfil"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 45,
              child: Icon(
                Icons.person,
                size: 50,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Bienvenido",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.admin_panel_settings),
                label: const Text("Panel de Administración"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminNavigation(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text("Cerrar sesión"),
                onPressed: () {
                  // Lo conectaremos con Firebase Auth más adelante.
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}