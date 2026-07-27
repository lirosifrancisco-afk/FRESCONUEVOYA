import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'historial_cliente_page.dart';

class AdminClientesPage extends StatefulWidget {
  const AdminClientesPage({super.key});

  @override
  State<AdminClientesPage> createState() =>
      _AdminClientesPageState();
}

class _AdminClientesPageState
    extends State<AdminClientesPage> {
final TextEditingController buscarController =
TextEditingController();

String textoBusqueda = "";

@override
void dispose() {
buscarController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("Administrar Clientes"),
),
body: Column(
children: [
Padding(
padding: const EdgeInsets.all(12),
child: TextField(
controller: buscarController,
decoration: InputDecoration(
hintText: "Buscar cliente...",
prefixIcon: const Icon(Icons.search),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
),
),
onChanged: (texto) {
setState(() {
textoBusqueda = texto.toLowerCase();
});
},
),
),

Expanded(
child: StreamBuilder<QuerySnapshot>(
stream: FirebaseFirestore.instance
.collection("usuarios")
.orderBy("nombre")
.snapshots(),
builder: (context, snapshot) {
if (snapshot.hasError) {
return Center(
child: Text(snapshot.error.toString()),
);
}

if (!snapshot.hasData) {
return const Center(
child: CircularProgressIndicator(),
);
}

var clientes = snapshot.data!.docs;

if (textoBusqueda.isNotEmpty) {
clientes = clientes.where((doc) {
final data =
doc.data() as Map<String, dynamic>;

final nombre =
(data["nombre"] ?? "")
.toString()
.toLowerCase();

return nombre.contains(textoBusqueda);
}).toList();
}

if (clientes.isEmpty) {
return const Center(
child: Text("No hay clientes."),
);
}

return ListView.builder(
itemCount: clientes.length,
itemBuilder: (context, index) {
final cliente =
clientes[index].data()
as Map<String, dynamic>;

final nombre =
cliente["nombre"] ?? "";

final telefono =
cliente["telefono"] ?? "";

final email =
cliente["email"] ?? "";

final direccion =
cliente["direccion"] ?? "";

final inicial = nombre.isEmpty
? "?"
: nombre[0].toUpperCase();

return Card(
elevation: 3,
margin: const EdgeInsets.symmetric(
horizontal: 12,
vertical: 6,
),
child: ListTile(
contentPadding:
const EdgeInsets.all(12),

leading: CircleAvatar(
radius: 28,
child: Text(
inicial,
style: const TextStyle(
fontWeight: FontWeight.bold,
fontSize: 20,
),
),
),

title: Text(
nombre,
style: const TextStyle(
fontWeight: FontWeight.bold,
fontSize: 17,
),
),

subtitle: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
const SizedBox(height: 8),

Row(
children: [
const Icon(
Icons.phone,
size: 16,
),
const SizedBox(width: 5),
Expanded(
child: Text(telefono),
),
],
),

const SizedBox(height: 5),

Row(
children: [
const Icon(
Icons.email,
size: 16,
),
const SizedBox(width: 5),
Expanded(
child: Text(email),
),
],
),

const SizedBox(height: 5),

Row(
children: [
const Icon(
Icons.home,
size: 16,
),
const SizedBox(width: 5),
Expanded(
child: Text(direccion),
),
],
),                            const SizedBox(height: 10),
],
),

  trailing: const Icon(
    Icons.arrow_forward_ios,
    size: 18,
  ),

  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HistorialClientePage(
          uid: clientes[index].id,
          nombre: nombre,
        ),
      ),
    );
  },
),
);
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