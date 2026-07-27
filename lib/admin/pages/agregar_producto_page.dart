import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/storage_service.dart';

class AgregarProductoPage extends StatefulWidget {
  const AgregarProductoPage({super.key});

  @override
  State<AgregarProductoPage> createState() => _AgregarProductoPageState();
}

class _AgregarProductoPageState extends State<AgregarProductoPage> {
final _formKey = GlobalKey<FormState>();

final TextEditingController nombreController = TextEditingController();
final TextEditingController precioController = TextEditingController();
final TextEditingController stockController = TextEditingController();

String unidad = "Kg";
String categoria = "Verduras";

bool guardando = false;

final ImagePicker picker = ImagePicker();
final StorageService storageService = StorageService();

XFile? imagenSeleccionada;
String imagenUrl = "";

Future<void> elegirImagen(ImageSource source) async {
final XFile? imagen = await picker.pickImage(
source: source,
imageQuality: 80,
);

if (imagen == null) return;

setState(() {
  imagenSeleccionada = imagen;
});
}

Future<void> subirImagen() async {
if (imagenSeleccionada == null) return;

final String? url =
await storageService.subirImagen(imagenSeleccionada!);

imagenUrl = url ?? "";
}

Future<void> guardarProducto() async {
if (!_formKey.currentState!.validate()) return;

setState(() {
guardando = true;
});

try {
await subirImagen();

await FirebaseFirestore.instance.collection("productos").add({
"nombre": nombreController.text.trim(),
"precio": double.parse(precioController.text),
"stock": int.parse(stockController.text),
"unidad": unidad,
"categoria": categoria,
"imagen": imagenUrl,
});

if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text("✅ Producto agregado correctamente"),
backgroundColor: Colors.green,
),
);

Navigator.pop(context);
} catch (e) {
if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text("Error: $e"),
backgroundColor: Colors.red,
),
);
} finally {
if (mounted) {
setState(() {
guardando = false;
});
}
}
}

@override
void dispose() {
nombreController.dispose();
precioController.dispose();
stockController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("Agregar Producto"),
),
body: Form(
key: _formKey,
child: ListView(
padding: const EdgeInsets.all(20),
children: [
TextFormField(
controller: nombreController,
decoration: const InputDecoration(
labelText: "Nombre",
border: OutlineInputBorder(),
),
validator: (value) {
if (value == null || value.trim().isEmpty) {
return "Ingrese el nombre";
}
return null;
},
),

const SizedBox(height: 20),

TextFormField(
controller: precioController,
keyboardType:
const TextInputType.numberWithOptions(decimal: true),
decoration: const InputDecoration(
labelText: "Precio",
border: OutlineInputBorder(),
),
validator: (value) {
if (value == null || value.isEmpty) {
return "Ingrese el precio";
}
return null;
},
),

const SizedBox(height: 20),

TextFormField(
controller: stockController,
keyboardType: TextInputType.number,
decoration: const InputDecoration(
labelText: "Stock",
border: OutlineInputBorder(),
),
validator: (value) {
if (value == null || value.isEmpty) {
return "Ingrese el stock";
}
return null;
},
),

const SizedBox(height: 20),

DropdownButtonFormField<String>(
value: unidad,
decoration: const InputDecoration(
labelText: "Unidad",
border: OutlineInputBorder(),
),
items: const [
DropdownMenuItem(value: "Kg", child: Text("Kg")),
DropdownMenuItem(value: "Unidad", child: Text("Unidad")),
DropdownMenuItem(value: "Bolsa", child: Text("Bolsa")),
DropdownMenuItem(value: "Cajón", child: Text("Cajón")),
DropdownMenuItem(value: "Atado", child: Text("Atado")),
],
onChanged: (value) {
setState(() {
unidad = value!;
});
},
),            const SizedBox(height: 20),

  DropdownButtonFormField<String>(
    value: categoria,
    decoration: const InputDecoration(
      labelText: "Categoría",
      border: OutlineInputBorder(),
    ),
    items: const [
      DropdownMenuItem(
        value: "Verduras",
        child: Text("Verduras"),
      ),
      DropdownMenuItem(
        value: "Frutas",
        child: Text("Frutas"),
      ),
      DropdownMenuItem(
        value: "Hortalizas",
        child: Text("Hortalizas"),
      ),
      DropdownMenuItem(
        value: "Otros",
        child: Text("Otros"),
      ),
    ],
    onChanged: (value) {
      setState(() {
        categoria = value!;
      });
    },
  ),

  const SizedBox(height: 25),

  if (imagenSeleccionada != null)
    ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.file(
        File(imagenSeleccionada!.path),
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    )
  else
    Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: const Center(
        child: Icon(
          Icons.image,
          size: 70,
          color: Colors.grey,
        ),
      ),
    ),

  const SizedBox(height: 15),

  Row(
    children: [
      Expanded(
        child: ElevatedButton.icon(
          onPressed: () => elegirImagen(ImageSource.camera),
          icon: const Icon(Icons.photo_camera),
          label: const Text("Cámara"),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: ElevatedButton.icon(
          onPressed: () => elegirImagen(ImageSource.gallery),
          icon: const Icon(Icons.photo_library),
          label: const Text("Galería"),
        ),
      ),
    ],
  ),

  const SizedBox(height: 30),

  SizedBox(
    height: 55,
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: guardando ? null : guardarProducto,
      icon: guardando
          ? const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      )
          : const Icon(Icons.save),
      label: Text(
        guardando
            ? "Guardando..."
            : "Guardar Producto",
      ),
    ),
  ),
],
),
),
);
}
}