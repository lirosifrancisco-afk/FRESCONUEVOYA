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
  late TextEditingController categoriaController;
  late TextEditingController cantidadPorUnidadController;

  String unidadMedida = 'kg';

  final List<String> unidadesDisponibles = const ['kg', 'unidad', 'caja'];

  @override
  void initState() {
    super.initState();

    nombreController = TextEditingController(
      text: widget.producto?.nombre ?? '',
    );

    precioController = TextEditingController(
      text: widget.producto != null
          ? widget.producto!.precio.toStringAsFixed(0)
          : '',
    );

    stockController = TextEditingController(
      text: widget.producto?.stock.toString() ?? '',
    );

    categoriaController = TextEditingController(
      text: widget.producto?.categoria ?? '',
    );

    cantidadPorUnidadController = TextEditingController(
      text: widget.producto?.cantidadPorUnidad.toString() ?? '1',
    );

    unidadMedida = widget.producto?.unidadMedida ?? widget.producto?.unidad ?? 'kg';
  }

  @override
  void dispose() {
    nombreController.dispose();
    precioController.dispose();
    stockController.dispose();
    categoriaController.dispose();
    cantidadPorUnidadController.dispose();
    super.dispose();
  }

  Future<void> guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<ProductosProvider>(context, listen: false);

    final nombre = nombreController.text.trim();
    final precio =
        double.tryParse(precioController.text.replaceAll(',', '.')) ?? 0;
    final stock = int.tryParse(stockController.text) ?? 0;
    final categoria = categoriaController.text.trim();
    final cantidadPorUnidad =
        double.tryParse(cantidadPorUnidadController.text.replaceAll(',', '.')) ??
            0;

    if (cantidadPorUnidad <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La cantidad por unidad debe ser mayor a 0')),
      );
      return;
    }

    if (widget.producto == null) {
      await provider.agregarProducto(
        nombre: nombre,
        precio: precio,
        stock: stock,
        unidad: unidadMedida,
        unidadMedida: unidadMedida,
        cantidadPorUnidad: cantidadPorUnidad,
        categoria: categoria,
      );
    } else {
      await provider.editarProducto(
        id: widget.producto!.id,
        nombre: nombre,
        precio: precio,
        stock: stock,
        unidad: unidadMedida,
        unidadMedida: unidadMedida,
        cantidadPorUnidad: cantidadPorUnidad,
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
          editando ? 'Editar Producto' : 'Nuevo Producto',
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
                labelText: 'Nombre',
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Ingrese un nombre' : null,
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: precioController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Precio',
              ),
              validator: (v) => v == null || v.isEmpty ? 'Ingrese un precio' : null,
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Stock',
              ),
              validator: (v) => v == null || v.isEmpty ? 'Ingrese el stock' : null,
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: unidadMedida,
              decoration: const InputDecoration(
                labelText: 'Unidad de medida',
              ),
              items: unidadesDisponibles
                  .map(
                    (unidad) => DropdownMenuItem(
                      value: unidad,
                      child: Text(unidad.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (valor) {
                setState(() {
                  unidadMedida = valor ?? 'kg';
                });
              },
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: cantidadPorUnidadController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Cantidad por unidad de venta',
                hintText: 'Ej: 1, 0.5, 2',
              ),
              validator: (v) {
                final cantidad = double.tryParse((v ?? '').replaceAll(',', '.'));
                if (cantidad == null || cantidad <= 0) {
                  return 'Ingrese una cantidad válida';
                }
                return null;
              },
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: categoriaController,
              decoration: const InputDecoration(
                labelText: 'Categoría',
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Ingrese la categoría' : null,
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(
                  editando ? 'GUARDAR CAMBIOS' : 'CREAR PRODUCTO',
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
