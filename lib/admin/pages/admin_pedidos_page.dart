import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'detalle_pedido_page.dart';

class AdminPedidosPage extends StatefulWidget {
  const AdminPedidosPage({super.key});

  @override
  State<AdminPedidosPage> createState() => _AdminPedidosPageState();
}

class _AdminPedidosPageState extends State<AdminPedidosPage> {
String _busqueda = "";
String _estadoSeleccionado = "Todos";

final List<String> _estados = [
"Todos",
"Pendiente",
"Preparando",
"En reparto",
"Entregado",
"Cancelado",
];

Color _colorEstado(String estado) {
switch (estado) {
case "Pendiente":
return Colors.orange;
case "Preparando":
return Colors.blue;
case "En reparto":
return Colors.purple;
case "Entregado":
return Colors.green;
case "Cancelado":
return Colors.red;
default:
return Colors.grey;
}
}

IconData _iconoEstado(String estado) {
switch (estado) {
case "Pendiente":
return Icons.schedule;
case "Preparando":
return Icons.inventory_2;
case "En reparto":
return Icons.local_shipping;
case "Entregado":
return Icons.check_circle;
case "Cancelado":
return Icons.cancel;
default:
return Icons.help;
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("Administrar pedidos"),
),
body: Column(
children: [
Padding(
padding: const EdgeInsets.all(12),
child: TextField(
decoration: const InputDecoration(
hintText: "Buscar cliente...",
prefixIcon: Icon(Icons.search),
),
onChanged: (value) {
setState(() {
_busqueda = value.toLowerCase();
});
},
),
),

Padding(
padding: const EdgeInsets.symmetric(horizontal: 12),
child: DropdownButtonFormField<String>(
value: _estadoSeleccionado,
decoration: const InputDecoration(
labelText: "Filtrar por estado",
),
items: _estados.map((estado) {
return DropdownMenuItem(
value: estado,
child: Text(estado),
);
}).toList(),
onChanged: (value) {
setState(() {
_estadoSeleccionado = value!;
});
},
),
),

const SizedBox(height: 10),

Expanded(
child: RefreshIndicator(
onRefresh: () async {
setState(() {});
},
child: StreamBuilder<QuerySnapshot>(
stream: FirebaseFirestore.instance
.collection("pedidos")
.orderBy("fecha", descending: true)
.snapshots(),
builder: (context, snapshot) {
if (snapshot.hasError) {
return Center(
child: Text(snapshot.error.toString()),
);
}

if (snapshot.connectionState ==
ConnectionState.waiting) {
return const Center(
child: CircularProgressIndicator(),
);
}

if (!snapshot.hasData ||
snapshot.data!.docs.isEmpty) {
return const Center(
child: Text("No hay pedidos"),
);
}

final pedidos = snapshot.data!.docs.where((doc) {
final pedido =
doc.data() as Map<String, dynamic>;

final nombre = (pedido["nombre"] ?? "")
.toString()
.toLowerCase();

final estado =
pedido["estado"] ?? "Pendiente";

final coincideBusqueda =
nombre.contains(_busqueda);

final coincideEstado =
_estadoSeleccionado == "Todos" ||
estado == _estadoSeleccionado;

return coincideBusqueda &&
coincideEstado;
}).toList();

if (pedidos.isEmpty) {
return const Center(
child: Text(
"No se encontraron pedidos.",
),
);
}

return ListView.builder(
padding: const EdgeInsets.only(bottom: 20),
itemCount: pedidos.length,
itemBuilder: (context, index) {
final pedido =
pedidos[index].data()
as Map<String, dynamic>;

final estado =
pedido["estado"] ?? "Pendiente";

final nombre =
pedido["nombre"] ?? "Sin nombre";

final total =
(pedido["total"] ?? 0).toDouble();

final cantidad =
(pedido["productos"] as List?)
?.length ??
0;

final fecha =
pedido["fecha"] as Timestamp?;

final fechaTexto = fecha == null
? "-"
: "${fecha.toDate().day.toString().padLeft(2, '0')}/"
"${fecha.toDate().month.toString().padLeft(2, '0')}/"
"${fecha.toDate().year}";

final horaTexto = fecha == null
? ""
: "${fecha.toDate().hour.toString().padLeft(2, '0')}:"
"${fecha.toDate().minute.toString().padLeft(2, '0')}";

return Card(
margin: const EdgeInsets.symmetric(
horizontal: 12,
vertical: 8,
),
child: ListTile(
leading: CircleAvatar(
backgroundColor:
_colorEstado(estado)
.withValues(alpha: .15),
child: Icon(
_iconoEstado(estado),
color: _colorEstado(estado),
),
),                          title: Text(
  nombre,
  style: const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 17,
  ),
),

  subtitle: Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [

        Chip(
          avatar: Icon(
            _iconoEstado(estado),
            size: 18,
            color: Colors.white,
          ),
          backgroundColor:
          _colorEstado(estado),
          label: Text(
            estado,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 6),

        Text(
          "$cantidad producto(s)",
        ),

        const SizedBox(height: 4),

        Text(
          "$fechaTexto   $horaTexto",
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          "TOTAL",
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          "\$ ${total.toStringAsFixed(0)}",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    ),
  ),

  trailing: const Icon(
    Icons.arrow_forward_ios,
    size: 18,
  ),

  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetallePedidoPage(
          pedidoId: pedidos[index].id,
          pedido: pedido,
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
),
],
),
);
}
}