import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistorialClientePage extends StatelessWidget {
final String uid;
final String nombre;

const HistorialClientePage({
super.key,
required this.uid,
required this.nombre,
});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text(nombre),
),
body: StreamBuilder<QuerySnapshot>(
stream: FirebaseFirestore.instance
.collection("pedidos")
.where("uidUsuario", isEqualTo: uid)
.orderBy("fecha", descending: true)
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

final pedidos = snapshot.data!.docs;

if (pedidos.isEmpty) {
return const Center(
child: Text("Este cliente todavía no realizó compras."),
);
}

return ListView.builder(
padding: const EdgeInsets.all(12),
itemCount: pedidos.length,
itemBuilder: (context, index) {

final pedido =
pedidos[index].data() as Map<String, dynamic>;

final estado =
pedido["estado"] ?? "";

final total =
(pedido["total"] as num?)?.toDouble() ?? 0;

final fecha =
pedido["fecha"] as Timestamp?;

final fechaTexto = fecha == null
? "-"
: "${fecha.toDate().day.toString().padLeft(2, '0')}/"
"${fecha.toDate().month.toString().padLeft(2, '0')}/"
"${fecha.toDate().year}";

return Card(
margin: const EdgeInsets.only(bottom: 12),
child: ListTile(
leading: const CircleAvatar(
child: Icon(Icons.shopping_bag),
),

title: Text(
"\$ ${total.toStringAsFixed(0)}",
style: const TextStyle(
fontWeight: FontWeight.bold,
),
),

subtitle: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [

const SizedBox(height: 5),

Text("Estado: $estado"),

Text("Fecha: $fechaTexto"),                      const SizedBox(height: 5),

  Chip(
    label: Text(estado),
    avatar: const Icon(
      Icons.local_shipping,
      size: 18,
    ),
  ),
],
),

  trailing: Text(
    "Ver",
    style: TextStyle(
      color: Theme.of(context).primaryColor,
      fontWeight: FontWeight.bold,
    ),
  ),

  onTap: () {
    // Próximamente:
    // Abrir DetallePedidoPage del pedido seleccionado.
  },
),
);
},
);
},
),
);
}
}