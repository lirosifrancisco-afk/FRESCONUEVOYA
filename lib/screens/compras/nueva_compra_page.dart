import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/producto.dart';
import '../../providers/compra_actual_provider.dart';
import '../../providers/productos_provider.dart';
import '../../services/compras_service.dart';

class NuevaCompraPage extends StatefulWidget {
  const NuevaCompraPage({super.key});

  @override
  State<NuevaCompraPage> createState() => _NuevaCompraPageState();
}

class _NuevaCompraPageState extends State<NuevaCompraPage> {
final TextEditingController proveedorController =
TextEditingController();

final TextEditingController buscarController =
TextEditingController();

final TextEditingController cantidadController =
TextEditingController();

final TextEditingController precioController =
TextEditingController();

Producto? productoSeleccionado;

@override
void dispose() {
proveedorController.dispose();
buscarController.dispose();
cantidadController.dispose();
precioController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
final compraProvider = context.watch<CompraActualProvider>();
final productosProvider = context.watch<ProductosProvider>();

final productos = productosProvider.buscar(
buscarController.text,
);

return Scaffold(
appBar: AppBar(
title: const Text("Nueva Compra"),
),
body: ListView(
padding: const EdgeInsets.all(16),
children: [

TextField(
controller: proveedorController,
decoration: const InputDecoration(
labelText: "Proveedor",
prefixIcon: Icon(Icons.store),
),
),

const SizedBox(height: 20),

Autocomplete<Producto>(
displayStringForOption: (p) => p.nombre,
optionsBuilder: (textEditingValue) {
if (textEditingValue.text.isEmpty) {
return const Iterable<Producto>.empty();
}

return productos.where(
(p) => p.nombre
.toLowerCase()
.contains(
textEditingValue.text.toLowerCase(),
),
);
},
onSelected: (producto) {
productoSeleccionado = producto;
},
fieldViewBuilder: (
context,
controller,
focusNode,
onEditingComplete,
) {
return TextField(
controller: controller,
focusNode: focusNode,
decoration: const InputDecoration(
labelText: "Buscar producto",
prefixIcon: Icon(Icons.search),
),
);
},
),

const SizedBox(height: 15),

Row(
children: [

Expanded(
child: TextField(
controller: cantidadController,
keyboardType: TextInputType.number,
decoration: const InputDecoration(
labelText: "Cantidad",
),
),
),

const SizedBox(width: 10),

Expanded(
child: TextField(
controller: precioController,
keyboardType: TextInputType.number,
decoration: const InputDecoration(
labelText: "Precio Compra",
),
),
),
],
),

const SizedBox(height: 20),

SizedBox(
height: 50,
child: ElevatedButton.icon(
icon: const Icon(Icons.add),
label: const Text("AGREGAR PRODUCTO"),
onPressed: () {
if (productoSeleccionado == null) return;

final cantidad =
int.tryParse(cantidadController.text) ?? 0;

final precio = double.tryParse(
precioController.text.replaceAll(",", "."),
) ??
0;

if (cantidad <= 0 || precio <= 0) return;

compraProvider.agregarProducto(
producto: productoSeleccionado!,
cantidad: cantidad,
precioCompra: precio,
);

cantidadController.clear();
precioController.clear();

setState(() {
productoSeleccionado = null;
});

FocusScope.of(context).unfocus();
},
),
),

const SizedBox(height: 30),          const Text(
"Productos agregados",
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 10),

if (compraProvider.productos.isEmpty)
const Card(
child: Padding(
padding: EdgeInsets.all(20),
child: Center(
child: Text(
"Todavía no agregaste productos.",
),
),
),
)
else
ListView.builder(
shrinkWrap: true,
physics: const NeverScrollableScrollPhysics(),
itemCount: compraProvider.productos.length,
itemBuilder: (context, index) {
final item = compraProvider.productos[index];

return Card(
margin: const EdgeInsets.only(bottom: 10),
child: ListTile(
leading: const CircleAvatar(
child: Icon(Icons.inventory_2),
),
title: Text(
item.producto.nombre,
style: const TextStyle(
fontWeight: FontWeight.bold,
),
),
subtitle: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Text(
"Cantidad: ${item.cantidad} ${item.producto.unidad}",
),
Text(
"Precio compra: \$${item.precioCompra.toStringAsFixed(0)}",
),
Text(
"Subtotal: \$${item.total.toStringAsFixed(0)}",
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
compraProvider.eliminarProducto(index);
},
),
),
);
},
),

const SizedBox(height: 25),

Card(
elevation: 4,
child: Padding(
padding: const EdgeInsets.all(18),
child: Row(
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
"\$${compraProvider.total.toStringAsFixed(0)}",
style: const TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
color: Colors.green,
),
),
],
),
),
),

const SizedBox(height: 30),          SizedBox(
    height: 55,
    child: ElevatedButton.icon(
      icon: const Icon(Icons.save),
      label: const Text(
        "GUARDAR COMPRA",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () async {
        if (proveedorController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Ingrese el proveedor.",
              ),
            ),
          );
          return;
        }

        if (compraProvider.productos.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Agregue al menos un producto.",
              ),
            ),
          );
          return;
        }

        final confirmar = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Confirmar compra"),
            content: Text(
              "¿Guardar esta compra por \$${compraProvider.total.toStringAsFixed(0)}?",
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(context, false),
                child: const Text("Cancelar"),
              ),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pop(context, true),
                child: const Text("Guardar"),
              ),
            ],
          ),
        );

        if (confirmar != true) return;

        try {
          await ComprasService().guardarCompra(
            proveedor: proveedorController.text.trim(),
            productos: compraProvider.productos,
          );

          compraProvider.limpiar();

          proveedorController.clear();
          buscarController.clear();
          cantidadController.clear();
          precioController.clear();

          productoSeleccionado = null;

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Compra guardada correctamente.",
              ),
            ),
          );

          Navigator.pop(context);
        } catch (e) {
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Error al guardar la compra:\n$e",
              ),
            ),
          );
        }
      },
    ),
  ),

  const SizedBox(height: 20),
],
),
);
}
}