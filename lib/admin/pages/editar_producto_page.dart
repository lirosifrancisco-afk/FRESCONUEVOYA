import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/producto.dart';
import '../../providers/productos_provider.dart';
import '../widgets/selector_imagen.dart';

class EditarProductoPage extends StatefulWidget {
  final Producto producto;

  const EditarProductoPage({
    super.key,
    required this.producto,
  });

  @override
  State<EditarProductoPage> createState() => _EditarProductoPageState();
}

class _EditarProductoPageState extends State<EditarProductoPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombreController;
  late final TextEditingController _precioController;
  late final TextEditingController _stockController;
  late final TextEditingController _cantidadPorUnidadController;

  late String _categoria;
  late String _unidad;
  late String _imagen;

  bool _guardando = false;

  final categorias = const [
    'Verduras',
    'Frutas',
    'Hortalizas',
    'Otros',
  ];

  final unidades = const [
    'kg',
    'unidad',
    'caja',
  ];

  @override
  void initState() {
    super.initState();

    _nombreController = TextEditingController(text: widget.producto.nombre);

    _precioController =
        TextEditingController(text: widget.producto.precio.toString());

    _stockController =
        TextEditingController(text: widget.producto.stock.toString());

    _cantidadPorUnidadController = TextEditingController(
      text: widget.producto.cantidadPorUnidad.toString(),
    );

    _categoria = widget.producto.categoria;
    _unidad = widget.producto.unidadMedida;
    _imagen = widget.producto.imagen;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _precioController.dispose();
    _stockController.dispose();
    _cantidadPorUnidadController.dispose();
    super.dispose();
  }

  Future<void> guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _guardando = true;
    });

    try {
      await context.read<ProductosProvider>().editarProducto(
            id: widget.producto.id,
            nombre: _nombreController.text.trim(),
            precio: double.parse(
              _precioController.text.replaceAll(',', '.'),
            ),
            stock: int.parse(_stockController.text),
            unidad: _unidad,
            unidadMedida: _unidad,
            cantidadPorUnidad:
                double.parse(_cantidadPorUnidadController.text.replaceAll(',', '.')),
            categoria: _categoria,
            imagen: _imagen,
          );

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Producto actualizado'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _guardando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  InputDecoration deco(String texto) {
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
        title: const Text('Editar Producto'),
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
              decoration: deco('Nombre'),
              validator: (v) => v == null || v.isEmpty ? 'Ingrese el nombre' : null,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _precioController,
              keyboardType: TextInputType.number,
              decoration: deco('Precio'),
              validator: (v) => v == null || v.isEmpty ? 'Ingrese el precio' : null,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _stockController,
              keyboardType: TextInputType.number,
              decoration: deco('Stock'),
              validator: (v) => v == null || v.isEmpty ? 'Ingrese el stock' : null,
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: _categoria,
              decoration: deco('Categoría'),
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
                  _categoria = v!;
                });
              },
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: _unidad,
              decoration: deco('Unidad de medida'),
              items: unidades
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                setState(() {
                  _unidad = v!;
                });
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _cantidadPorUnidadController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: deco('Cantidad por unidad de venta'),
              validator: (v) {
                final valor = double.tryParse((v ?? '').replaceAll(',', '.'));
                if (valor == null || valor <= 0) {
                  return 'Ingresá una cantidad válida';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            FilledButton.icon(
              onPressed: _guardando ? null : guardar,
              icon: const Icon(Icons.save),
              label: Text(
                _guardando ? 'Guardando...' : 'Actualizar Producto',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
