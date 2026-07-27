import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/producto.dart';
import '../../providers/productos_provider.dart';
import '../../providers/venta_actual_provider.dart';

class NuevaVentaPage extends StatefulWidget {
  const NuevaVentaPage({super.key});

  @override
  State<NuevaVentaPage> createState() => _NuevaVentaPageState();
}

class _NuevaVentaPageState extends State<NuevaVentaPage> {
final TextEditingController buscarController =
TextEditingController();

final TextEditingController cantidadController =
TextEditingController(text: "1");

final TextEditingController precioController =
TextEditingController();

Producto? productoSeleccionado;

@override
void dispose() {
buscarController.dispose();
cantidadController.dispose();
precioController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
final productosProvider =
Provider.of<ProductosProvider>(context);

final ventaProvider =
Provider.of<VentaActualProvider>(context);

final productos =
productosProvider.buscar(buscarController.text);

return Scaffold(
appBar: AppBar(
title: const Text("Nueva Venta"),
),
body: SafeArea(
child: Column(
children: [

Padding(
padding: const EdgeInsets.all(12),

child: TextField(
controller: buscarController,

decoration: const InputDecoration(
hintText: "Buscar producto...",
prefixIcon: Icon(Icons.search),
),

onChanged: (value) {
setState(() {});
},
),
),

if (productoSeleccionado == null)

Expanded(
child: ListView.builder(
itemCount: productos.length,

itemBuilder: (context, index) {

final producto = productos[index];

return ListTile(

leading: const CircleAvatar(
child: Icon(Icons.shopping_basket),
),

title: Text(producto.nombre),

subtitle: Text(
"${producto.categoria} - Stock ${producto.stock}",
),

trailing: Text(
"\$${producto.precio.toStringAsFixed(0)}",
),

onTap: () {

setState(() {

productoSeleccionado = producto;

cantidadController.text = "1";

precioController.text =
producto.precio.toStringAsFixed(0);

buscarController.clear();

});

},

);

},

),

),

if (productoSeleccionado != null)

Card(

margin: const EdgeInsets.all(12),

child: Padding(

padding: const EdgeInsets.all(16),

child: Column(

children: [

Text(

productoSeleccionado!.nombre,

style: const TextStyle(

fontWeight: FontWeight.bold,

fontSize: 22,

),

),

const SizedBox(height: 20),

Row(

children: [

Expanded(

child: TextField(

controller: cantidadController,

keyboardType:
TextInputType.number,

decoration:
const InputDecoration(

labelText: "Cantidad",

),

),

),

const SizedBox(width: 10),

Expanded(

child: TextField(

controller: precioController,

keyboardType:
TextInputType.number,

decoration:
const InputDecoration(

labelText: "Precio",

),

),

),

],

),

const SizedBox(height: 20),                      SizedBox(
width: double.infinity,
child: ElevatedButton.icon(
icon: const Icon(Icons.add),
label: const Text("Agregar a la venta"),
onPressed: () {
final cantidad =
int.tryParse(cantidadController.text) ?? 1;

final precio =
double.tryParse(precioController.text) ?? 0;

ventaProvider.agregarProducto(
producto: productoSeleccionado!,
cantidad: cantidad,
precio: precio,
);

setState(() {
productoSeleccionado = null;
buscarController.clear();
cantidadController.text = "1";
precioController.clear();
});
},
),
),

const SizedBox(height: 10),

SizedBox(
width: double.infinity,
child: OutlinedButton.icon(
icon: const Icon(Icons.close),
label: const Text("Cancelar"),
onPressed: () {
setState(() {
productoSeleccionado = null;
buscarController.clear();
cantidadController.text = "1";
precioController.clear();
});
},
),
),
],
),
),
),

const Divider(height: 1),

Expanded(
child: Consumer<VentaActualProvider>(
builder: (context, venta, _) {
if (venta.items.isEmpty) {
return const Center(
child: Text(
"Todavía no agregaste productos",
style: TextStyle(
fontSize: 16,
color: Colors.grey,
),
),
);
}

return ListView.builder(
itemCount: venta.items.length,
itemBuilder: (context, index) {
final item = venta.items[index];

return Card(
margin: const EdgeInsets.symmetric(
horizontal: 12,
vertical: 5,
),
child: ListTile(
leading: CircleAvatar(
child: Text(
item.cantidad.toString(),
),
),

title: Text(item.producto.nombre),

subtitle: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Text(
"Precio: \$${item.precio.toStringAsFixed(0)}",
),
Text(
"Total: \$${item.total.toStringAsFixed(0)}",
style: const TextStyle(
fontWeight: FontWeight.bold,
),
),
],
),

trailing: IconButton(
icon: const Icon(
Icons.delete,
color: Colors.red,
),
onPressed: () {
venta.eliminarProducto(index);
},
),
),
);
},
);
},
),
),            Consumer<VentaActualProvider>(
    builder: (context, venta, _) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          border: const Border(
            top: BorderSide(color: Colors.green),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "TOTAL",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "\$${venta.totalGeneral.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text(
                  "GUARDAR VENTA",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: venta.estaVacia
                    ? null
                    : () async {
                  try {
                    await venta.guardarVenta();

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Venta guardada correctamente",
                        ),
                      ),
                    );
                  } catch (e) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      SnackBar(
                        content: Text(
                          "Error: $e",
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      );
    },
  ),
],
),
),
);
}
}