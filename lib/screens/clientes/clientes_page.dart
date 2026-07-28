import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cliente.dart';
import '../../providers/clientes_provider.dart';

import 'widgets/cliente_card.dart';
import 'widgets/dialog_cliente.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
final TextEditingController buscarController = TextEditingController();

@override
void dispose() {
buscarController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
final provider = context.watch<ClientesProvider>();

final List<Cliente> clientes =
provider.buscar(buscarController.text);

return Scaffold(
appBar: AppBar(
title: const Text("Clientes"),
),
floatingActionButton: FloatingActionButton.extended(
onPressed: () {
showDialog(
context: context,
builder: (_) => const DialogCliente(),
);
},
icon: const Icon(Icons.person_add),
label: const Text("Nuevo"),
),
body: Column(
children: [
Padding(
padding: const EdgeInsets.all(16),
child: TextField(
controller: buscarController,
decoration: const InputDecoration(
hintText: "Buscar cliente...",
prefixIcon: Icon(Icons.search),
),
onChanged: (_) {
setState(() {});
},
),
),          Expanded(
    child: provider.cargando
        ? const Center(
      child: CircularProgressIndicator(),
    )
        : clientes.isEmpty
        ? const Center(
      child: Text(
        "No hay clientes registrados",
        style: TextStyle(fontSize: 16),
      ),
    )
        : ListView.builder(
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
        bottom: 90,
      ),
      itemCount: clientes.length,
      itemBuilder: (context, index) {
        final cliente = clientes[index];

        return ClienteCard(
          cliente: cliente,
          onEditar: () {
            showDialog(
              context: context,
              builder: (_) => DialogCliente(
                cliente: cliente,
              ),
            );
          },
          onEliminar: () async {
            final eliminar =
                await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text(
                      "Eliminar cliente",
                    ),
                    content: Text(
                      "¿Eliminar a ${cliente.nombre}?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(
                              context,
                              false,
                            ),
                        child: const Text(
                          "Cancelar",
                        ),
                      ),
                      FilledButton(
                        onPressed: () =>
                            Navigator.pop(
                              context,
                              true,
                            ),
                        child: const Text(
                          "Eliminar",
                        ),
                      ),
                    ],
                  ),
                ) ??
                    false;

            if (eliminar) {
              await provider.eliminarCliente(
                cliente.id,
              );

              if (context.mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Cliente eliminado correctamente",
                    ),
                  ),
                );
              }
            }
          },
        );
      },
    ),
  ),
],
),
);
}
}