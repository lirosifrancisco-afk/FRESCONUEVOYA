import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/producto.dart';
import '../providers/carrito_provider.dart';
import 'carrito.dart';

class CatalogoPage extends StatefulWidget {
  const CatalogoPage({super.key});

  @override
  State<CatalogoPage> createState() => _CatalogoPageState();
}

class _CatalogoPageState extends State<CatalogoPage> {
String buscar = "";

@override
Widget build(BuildContext context) {
final carritoProvider =
context.watch<CarritoProvider>();

return Scaffold(
appBar: AppBar(
title: const Text("Catálogo"),
centerTitle: true,
),
body: Column(
children: [
Padding(
padding: const EdgeInsets.all(10),
child: TextField(
decoration: const InputDecoration(
hintText: "Buscar producto...",
prefixIcon: Icon(Icons.search),
border: OutlineInputBorder(),
),
onChanged: (value) {
setState(() {
buscar = value.toLowerCase();
});
},
),
),

Expanded(
child: StreamBuilder<QuerySnapshot>(
stream: FirebaseFirestore.instance
.collection("productos")
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

var productos = snapshot.data!.docs;

if (buscar.isNotEmpty) {
productos = productos.where((doc) {
final data =
doc.data() as Map<String, dynamic>;

final nombre =
(data["nombre"] ?? "")
.toString()
.toLowerCase();

return nombre.contains(buscar);
}).toList();
}

if (productos.isEmpty) {
return const Center(
child: Text(
"No hay productos disponibles",
),
);
}

return ListView.builder(
itemCount: productos.length,
itemBuilder: (context, index) {

final data =
productos[index].data()
as Map<String, dynamic>;

final producto = Producto(
id: productos[index].id,
nombre: data["nombre"] ?? "",
precio: (data["precio"] as num?)
?.toDouble() ??
0,
cantidad: 1,
stock: (data["stock"] as num?)
?.toInt() ??
0,
unidad: (data["unidad"] ?? "unidad").toString(),
unidadMedida: (data["unidadMedida"] ?? data["unidad"] ?? "unidad").toString(),
cantidadPorUnidad: (data["cantidadPorUnidad"] as num?)?.toDouble() ?? 1,
categoria:
data["categoria"] ?? "",
imagen: data["imagen"] ?? "",
);                    return Card(
  margin: const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
  ),
  elevation: 3,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: ListTile(
    contentPadding: const EdgeInsets.all(10),

    leading: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: producto.imagen.isNotEmpty
          ? Image.network(
        producto.imagen,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            width: 70,
            height: 70,
            color: Colors.grey.shade300,
            child: const Icon(Icons.image),
          );
        },
      )
          : Container(
        width: 70,
        height: 70,
        color: Colors.grey.shade300,
        child: const Icon(Icons.image),
      ),
    ),

    title: Text(
      producto.nombre,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 17,
      ),
    ),

    subtitle: Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Text(
          "\$ ${producto.precio.toStringAsFixed(0)} / ${producto.cantidadPorUnidad} ${producto.unidadMedida}",
        ),
        Text("Stock: ${producto.stock}"),
        Text("Categoría: ${producto.categoria}"),
      ],
    ),

    trailing: IconButton(
      icon: const Icon(
        Icons.add_shopping_cart,
        color: Colors.green,
        size: 30,
      ),
      onPressed: () {
        context
            .read<CarritoProvider>()
            .agregarProducto(producto);

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              "${producto.nombre} agregado al carrito",
            ),
            duration:
            const Duration(seconds: 1),
          ),
        );
      },
    ),
  ),
);
},
);
},
),
),
],
),

  floatingActionButton:
  FloatingActionButton.extended(
    backgroundColor: Colors.green,
    icon: const Icon(Icons.shopping_cart),
    label: Text(
      carritoProvider.productos.length.toString(),
    ),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const CarritoPage(),
        ),
      );
    },
  ),
);
}
}