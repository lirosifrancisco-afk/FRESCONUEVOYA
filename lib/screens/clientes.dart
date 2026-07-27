import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/clientes_provider.dart';

class ClientesPage extends StatelessWidget {
  const ClientesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final clientes = context.watch<ClientesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Clientes"),
      ),
      body: ListView.builder(
        itemCount: clientes.clientes.length,
        itemBuilder: (context, index) {
          final cliente = clientes.clientes[index];

          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(cliente.nombre),
            subtitle: Text(cliente.telefono),
          );
        },
      ),
    );
  }
}