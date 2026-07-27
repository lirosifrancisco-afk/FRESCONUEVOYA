import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cliente.dart';
import '../../providers/clientes_provider.dart';
import 'cliente_form_page.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
final TextEditingController buscarController =
TextEditingController();

@override
void dispose() {
buscarController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
final provider = context.watch<ClientesProvider>();

final clientes = provider.buscar(
buscarController.text,
);

return Scaffold(
appBar: AppBar(
title: const Text("Clientes"),
),

body: Column(
children: [

Padding(
padding: const EdgeInsets.all(12),
child: TextField(
controller: buscarController,
decoration: const InputDecoration(
prefixIcon: Icon(Icons.search),
hintText: "Buscar cliente...",
),
onChanged: (_) => setState(() {}),
),
),

Expanded(
child: provider.cargando
? const Center(
child: CircularProgressIndicator(),
)
: clientes.isEmpty
? const Center(
child: Text(
"No hay clientes registrados.",
),
)
: ListView.builder(
itemCount: clientes.length,
itemBuilder: (context, index) {
final Cliente cliente =
clientes[index];                          return Card(
margin: const EdgeInsets.symmetric(
horizontal: 12,
vertical: 6,
),
child: ListTile(
leading: CircleAvatar(
backgroundColor: Colors.green.shade100,
child: const Icon(
Icons.person,
color: Colors.green,
),
),
title: Text(
cliente.nombre,
style: const TextStyle(
fontWeight: FontWeight.bold,
fontSize: 16,
),
),
subtitle: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
if (cliente.telefono.isNotEmpty)
Text(
"📞 ${cliente.telefono}",
),
if (cliente.direccion.isNotEmpty)
Text(
"📍 ${cliente.direccion}",
),
],
),
trailing: Row(
mainAxisSize: MainAxisSize.min,
children: [
IconButton(
icon: const Icon(
Icons.edit,
color: Colors.blue,
),
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (_) =>
ClienteFormPage(
cliente: cliente,
),
),
);
},
),
IconButton(
icon: const Icon(
Icons.delete,
color: Colors.red,
),
onPressed: () async {
final confirmar =
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
ElevatedButton(
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
);

if (confirmar == true) {
await provider
.eliminarCliente(
cliente.id,
);
}
},
),
],
),
),
);
},
),          ),
],
),

  floatingActionButton: FloatingActionButton(
    child: const Icon(Icons.person_add),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ClienteFormPage(),
        ),
      );
    },
  ),
);
}
}