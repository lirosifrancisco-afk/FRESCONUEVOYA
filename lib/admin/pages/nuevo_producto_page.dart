import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/productos_provider.dart';
import '../widgets/selector_imagen.dart';

class NuevoProductoPage extends StatefulWidget {
  const NuevoProductoPage({super.key});

  @override
  State<NuevoProductoPage> createState() => _NuevoProductoPageState();
}

class _NuevoProductoPageState extends State<NuevoProductoPage> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _precioController = TextEditingController();
  final _stockController = TextEditingController();

  String _categoria = "";
  String _unidad = "";
  String _imagen = "";

  bool _guardando = false;

  final List<String> categorias = [
    "Verduras",
    "Frutas",
    "Hortalizas",
    "Otros",
  ];

  final List<String> unidades = [
    "Kg",
    "Unidad",
    "Cajón",
    "Bolsa",
    "Atado",
  ];

  @override
  void dispose() {
    _nombreController.dispose();
    _precioController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> guardar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_categoria.isEmpty || _unidad.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Debe seleccionar una categoría y una unidad."),
        ),
      );
      return;
    }

    setState(() {
      _guardando = true;
    });

    try {
      await context.read<ProductosProvider>().agregarProducto(
        nombre: _nombreController.text.trim(),
        precio: double.parse(_precioController.text.replaceAll(",", ".")),
        stock: int.parse(_stockController.text),
        unidad: _unidad,
        categoria: _categoria,
        imagen: _imagen,
      );

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Producto agregado correctamente"),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _guardando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }

  InputDecoration decoracion(String texto) {
    return InputDecoration(
      labelText: texto,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nuevo Producto"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            SelectorImagen(
              imagenInicial: _imagen,
              onImagenSubida: (url) {
                _imagen = url;
              },
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: _nombreController,
              decoration: decoracion("Nombre"),
              validator: (v) =>
              v == null || v.trim().isEmpty ? "Ingrese el nombre" : null,
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: _precioController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: decoracion("Precio"),
              validator: (v) =>
              v == null || v.trim().isEmpty ? "Ingrese el precio" : null,
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: _stockController,
              keyboardType: TextInputType.number,
              decoration: decoracion("Stock"),
              validator: (v) =>
              v == null || v.trim().isEmpty ? "Ingrese el stock" : null,
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              decoration: decoracion("Categoría"),
              value: _categoria.isEmpty ? null : _categoria,
              items: categorias
                  .map(
                    (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
                  .toList(),
              onChanged: (v) {
                setState(() {
                  _categoria = v ?? "";
                });
              },
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              decoration: decoracion("Unidad"),
              value: _unidad.isEmpty ? null : _unidad,
              items: unidades
                  .map(
                    (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
                  .toList(),
              onChanged: (v) {
                setState(() {
                  _unidad = v ?? "";
                });
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 55,
              child: FilledButton.icon(
                onPressed: _guardando ? null : guardar,
                icon: _guardando
                    ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(Icons.save),
                label: Text(
                  _guardando ? "Guardando..." : "Guardar Producto",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}