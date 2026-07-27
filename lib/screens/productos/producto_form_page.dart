import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/producto.dart';
import '../../providers/productos_provider.dart';

class ProductoFormPage extends StatefulWidget {
  final Producto? producto;

  const ProductoFormPage({
    super.key,
    this.producto,
  });

  @override
  State<ProductoFormPage> createState() => _ProductoFormPageState();
}

class _ProductoFormPageState extends State<ProductoFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nombreController;
  late TextEditingController precioController;
  late TextEditingController stockController;
  late TextEditingController unidadController;
  late TextEditingController categoriaController;

  @override
  void initState() {
    super.initState();

    nombreController = TextEditingController(
      text: widget.producto?.nombre ?? "",
    );

    precioController = TextEditingController(
      text: widget.producto != null
          ? widget.producto!.precio.toStringAsFixed(0)
          : "",
    );

    stockController = TextEditingController(
      text: widget.producto?.stock.toString() ?? "",
    );

    unidadController = TextEditingController(
      text: widget.producto?.unidad ?? "",
    );

    categoriaController = TextEditingController(
      text: widget.producto?.categoria ?? "",
    );
  }

  @override
  void dispose() {
    nombreController.dispose();
    precioController.dispose();
    stockController.dispose();
    unidadController.dispose();
    categoriaController.dispose();
    super.dispose();
  }

  Future<void> guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final provider =
    Provider.of<ProductosProvider>(context, listen: false);

    final nombre = nombreController.text.trim();
    final precio =
        double.tryParse(precioController.text.replaceAll(",", ".")) ?? 0;
    final stock = int.tryParse(stockController.text) ?? 0;
    final unidad = unidadController.text.trim();
    final categoria = categoriaController.text.trim();

    if (widget.producto == null) {
      await provider.agregarProducto(
        nombre: nombre,
        precio: precio,
        stock: stock,
        unidad: unidad,
        categoria: categoria,
      );
    } else {
      await provider.editarProducto(
        id: widget.producto!.id,
        nombre: nombre,
        precio: precio,
        stock: stock,
        unidad: unidad,
        categoria: categoria,
      );
    }

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.producto != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editando ? "Editar Producto" : "Nuevo Producto",
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: "Nombre",
              ),
              validator: (v) =>
              v == null || v.trim().isEmpty
                  ? "Ingrese un nombre"
                  : null,
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: precioController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Precio",
              ),
              validator: (v) =>
              v == null || v.isEmpty
                  ? "Ingrese un precio"
                  : null,
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Stock",
              ),
              validator: (v) =>
              v == null || v.isEmpty
                  ? "Ingrese el stock"
                  : null,
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: unidadController,
              decoration: const InputDecoration(
                labelText: "Unidad",
                hintText: "Caja, Bolsa, Kg...",
              ),
              validator: (v) =>
              v == null || v.trim().isEmpty
                  ? "Ingrese la unidad"
                  : null,
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: categoriaController,
              decoration: const InputDecoration(
                labelText: "Categoría",
              ),
              validator: (v) =>
              v == null || v.trim().isEmpty
                  ? "Ingrese la categoría"
                  : null,
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(
                  editando
                      ? "GUARDAR CAMBIOS"
                      : "CREAR PRODUCTO",
                ),
                onPressed: guardar,
              ),
            ),
          ],
        ),
      ),
    );
  }
}