import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'reporte_pdf_page.dart';

class AdminReportesPage extends StatefulWidget {
  const AdminReportesPage({super.key});

  @override
  State<AdminReportesPage> createState() => _AdminReportesPageState();
}

class _AdminReportesPageState extends State<AdminReportesPage> {

Future<Map<String, dynamic>> obtenerDatos() async {
final pedidos =
await FirebaseFirestore.instance.collection("pedidos").get();

double ventas = 0;
int cantidadPedidos = pedidos.docs.length;

for (final doc in pedidos.docs) {
final data = doc.data();
ventas += (data["total"] as num?)?.toDouble() ?? 0;
}

final ticketPromedio =
cantidadPedidos == 0 ? 0 : ventas / cantidadPedidos;

return {
"ventas": ventas,
"pedidos": cantidadPedidos,
"ticket": ticketPromedio,
};
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("Reportes"),
centerTitle: true,
),
body: FutureBuilder<Map<String, dynamic>>(
future: obtenerDatos(),
builder: (context, snapshot) {

if (snapshot.connectionState == ConnectionState.waiting) {
return const Center(
child: CircularProgressIndicator(),
);
}

if (snapshot.hasError) {
return Center(
child: Text(snapshot.error.toString()),
);
}

final datos = snapshot.data!;

return ListView(
padding: const EdgeInsets.all(16),
children: [

const SizedBox(height: 10),

SingleChildScrollView(
scrollDirection: Axis.horizontal,
child: Row(
children: [
FilterChip(
label: const Text("Hoy"),
selected: true,
onSelected: (_) {},
),
const SizedBox(width: 8),
FilterChip(
label: const Text("Semana"),
selected: false,
onSelected: (_) {},
),
const SizedBox(width: 8),
FilterChip(
label: const Text("Mes"),
selected: false,
onSelected: (_) {},
),
const SizedBox(width: 8),
FilterChip(
label: const Text("Año"),
selected: false,
onSelected: (_) {},
),
],
),
),

const SizedBox(height: 20),              _card(
Icons.attach_money,
Colors.green,
"Ventas Totales",
"\$ ${datos["ventas"].toStringAsFixed(0)}",
),

_card(
Icons.shopping_cart,
Colors.orange,
"Cantidad de Pedidos",
datos["pedidos"].toString(),
),

_card(
Icons.bar_chart,
Colors.blue,
"Ticket Promedio",
"\$ ${datos["ticket"].toStringAsFixed(0)}",
),

const SizedBox(height: 30),

ElevatedButton.icon(
icon: const Icon(Icons.picture_as_pdf),
label: const Text("Generar PDF"),
style: ElevatedButton.styleFrom(
backgroundColor: Colors.red,
foregroundColor: Colors.white,
minimumSize: const Size(double.infinity, 55),
),
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (_) => const ReportePdfPage(),
),
);
},
),

const SizedBox(height: 15),

OutlinedButton.icon(
icon: const Icon(Icons.table_chart),
label: const Text("Exportar Excel"),
style: OutlinedButton.styleFrom(
minimumSize: const Size(double.infinity, 55),
),
onPressed: () {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text("Próximamente disponible"),
),
);
},
),

const SizedBox(height: 30),

const Text(
"Próximamente",
style: TextStyle(
fontSize: 22,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 10),

const ListTile(
leading: Icon(Icons.show_chart),
title: Text("Gráfico de ventas"),
),

const ListTile(
leading: Icon(Icons.star),
title: Text("Productos más vendidos"),
),

const ListTile(
leading: Icon(Icons.people),
title: Text("Mejores clientes"),
),

const ListTile(
leading: Icon(Icons.inventory),
title: Text("Control de stock"),
),

const ListTile(
leading: Icon(Icons.calendar_month),
title: Text("Ventas por día, semana y mes"),
),

],
);
},
),
);
}  Widget _card(
    IconData icon,
    Color color,
    String titulo,
    String valor,
    ) {
  return Card(
    elevation: 4,
    margin: const EdgeInsets.only(bottom: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}