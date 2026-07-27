import 'package:flutter/material.dart';

import 'home_page.dart';
import 'carrito_page.dart';
import 'pedidos_page.dart';
import 'perfil_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _paginaActual = 0;

  @override
  Widget build(BuildContext context) {
    final paginas = [
      const HomePage(),
      const CarritoPage(),
      const PedidosPage(),
      const PerfilPage(),
    ];

    return Scaffold(
      body: paginas[_paginaActual],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _paginaActual,
        onDestinationSelected: (index) {
          setState(() => _paginaActual = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Pedidos',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}