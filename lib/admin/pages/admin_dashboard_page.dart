import 'package:flutter/material.dart';

import '../services/admin_service.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/charts/ventas_chart.dart';
import '../widgets/charts/estados_pedidos_chart.dart';
import 'admin_pedidos_page.dart';
import 'productos_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final admin = AdminService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel Administrador"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.shade700,
                    Colors.green.shade500,
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.storefront,
                    color: Colors.white,
                    size: 42,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Panel de Administración",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Administrá productos, pedidos, clientes y ventas desde un solo lugar.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.2,
              children: [
                DashboardCard(
                  icon: Icons.attach_money,
                  color: Colors.green,
                  titulo: "Ventas Hoy",
                  future: admin.ventasHoy(),
                ),
                DashboardCard(
                  icon: Icons.shopping_cart,
                  color: Colors.orange,
                  titulo: "Pedidos Hoy",
                  future: admin.pedidosHoy(),
                ),
                DashboardCard(
                  icon: Icons.receipt_long,
                  color: Colors.blue,
                  titulo: "Ticket Prom.",
                  future: admin.ticketPromedio(),
                ),
                DashboardCard(
                  icon: Icons.people,
                  color: Colors.purple,
                  titulo: "Clientes",
                  future: admin.totalClientes(),
                ),
              ],
            ),

            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.25,
              children: [

                DashboardCard(
                  icon: Icons.shopping_bag,
                  color: Colors.orange,
                  titulo: "Pedidos",
                  future: admin.pedidosPendientes(),
                ),

                DashboardCard(
                  icon: Icons.inventory,
                  color: Colors.green,
                  titulo: "Productos",
                  future: admin.totalProductos(),
                ),

                DashboardCard(
                  icon: Icons.people,
                  color: Colors.blue,
                  titulo: "Clientes",
                  future: admin.totalClientes(),
                ),

                DashboardCard(
                  icon: Icons.attach_money,
                  color: Colors.purple,
                  titulo: "Ventas",
                  future: admin.ventasTotales(),
                ),

                DashboardCard(
                  icon: Icons.warning_amber_rounded,
                  color: Colors.amber,
                  titulo: "Stock Bajo",
                  future: admin.productosStockBajo(),
                ),

                DashboardCard(
                  icon: Icons.cancel,
                  color: Colors.red,
                  titulo: "Sin Stock",
                  future: admin.productosSinStock(),
                ),
              ],
            ),

        const SizedBox(height: 25),

        FutureBuilder<List<double>>(
          future: admin.ventasPorMes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              return const SizedBox();
            }

            return VentasChart(
              ventas: snapshot.data ?? List.filled(12, 0),
            );
          },
        ),

            const SizedBox(height: 25),

            FutureBuilder<Map<String, int>>(
              future: admin.estadosPedidos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final datos = snapshot.data ??
                    {
                      "pendientes": 0,
                      "preparando": 0,
                      "entregados": 0,
                      "cancelados": 0,
                    };

                return EstadosPedidosChart(
                  pendientes: datos["pendientes"] ?? 0,
                  preparando: datos["preparando"] ?? 0,
                  entregados: datos["entregados"] ?? 0,
                  cancelados: datos["cancelados"] ?? 0,
                );
              },
            ),

        const SizedBox(height: 25),

        FutureBuilder<int>(
          future: admin.productosStockBajo(),
          builder: (context, snapshot) {
            final stockBajo = snapshot.data ?? 0;

            if (stockBajo == 0) {
              return const SizedBox();
            }

            return Card(
              color: Colors.orange.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                  ),
                ),
                title: const Text(
                  "Atención",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Hay $stockBajo productos con stock bajo.",
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 25),

        const Text(
          "Accesos rápidos",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),


            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.inventory),
                    label: const Text("Productos"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProductosPage(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text("Pedidos"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const AdminPedidosPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}