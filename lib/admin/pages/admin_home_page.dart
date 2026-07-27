import 'package:flutter/material.dart';

import 'admin_clientes_page.dart';
import 'admin_dashboard_page.dart';
import 'admin_pedidos_page.dart';
import 'productos_page.dart';
import 'admin_reportes_page.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel de Administración"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                children: [
                  _boton(
                    context,
                    "Dashboard",
                    Icons.dashboard,
                    Colors.indigo,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminDashboardPage(),
                        ),
                      );
                    },
                  ),
                  _boton(
                    context,
                    "Pedidos",
                    Icons.shopping_bag,
                    Colors.orange,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminPedidosPage(),
                        ),
                      );
                    },
                  ),
                  _boton(
                    context,
                    "Productos",
                    Icons.shopping_cart,
                    Colors.green,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProductosPage(),
                        ),
                      );
                    },
                  ),
                  _boton(
                    context,
                    "Clientes",
                    Icons.people,
                    Colors.blue,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminClientesPage(),
                        ),
                      );
                    },
                  ),
                  _boton(
                    context,
                    "Reportes",
                    Icons.bar_chart,
                    Colors.purple,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminReportesPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Botón informativo o de prueba seguro
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.info_outline, size: 26),
                label: const Text(
                  "Panel de Control Frecoya",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Panel de administración activo y funcionando."),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _boton(
      BuildContext context,
      String titulo,
      IconData icono,
      Color color,
      VoidCallback onTap,
      ) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(
                icono,
                color: color,
                size: 36,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}