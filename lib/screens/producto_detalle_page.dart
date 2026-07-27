import 'package:flutter/material.dart';

import '../models/producto.dart';
import '../shared/theme/app_colors.dart';
import '../shared/theme/app_text_styles.dart';
import '../shared/widgets/app_button.dart';

class ProductoDetallePage extends StatefulWidget {
  final Producto producto;
  final Function(Producto) onAgregar;

  const ProductoDetallePage({
    super.key,
    required this.producto,
    required this.onAgregar,
  });

  @override
  State<ProductoDetallePage> createState() =>
      _ProductoDetallePageState();
}

class _ProductoDetallePageState
    extends State<ProductoDetallePage> {
int cantidad = 1;

@override
Widget build(BuildContext context) {
final total = widget.producto.precio * cantidad;

return Scaffold(
appBar: AppBar(
title: Text(
widget.producto.nombre,
style: AppTextStyles.subtitulo.copyWith(
color: Colors.white,
),
),
),
body: SingleChildScrollView(
padding: const EdgeInsets.all(20),
child: Column(
children: [
ClipRRect(
borderRadius: BorderRadius.circular(18),
child: widget.producto.imagen.isNotEmpty
? Image.network(
widget.producto.imagen,
width: double.infinity,
height: 250,
fit: BoxFit.cover,
errorBuilder: (_, __, ___) =>
_imagenVacia(),
)
: _imagenVacia(),
),

const SizedBox(height: 24),

Text(
widget.producto.nombre,
style: AppTextStyles.titulo,
textAlign: TextAlign.center,
),

const SizedBox(height: 10),

Text(
"\$${widget.producto.precio.toStringAsFixed(0)} / ${widget.producto.unidad}",
style: AppTextStyles.precio,
),

const SizedBox(height: 15),

Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const Icon(
Icons.inventory_2,
color: Colors.grey,
),
const SizedBox(width: 6),
Text(
"Stock disponible: ${widget.producto.stock}",
style: AppTextStyles.descripcion,
),
],
),

const SizedBox(height: 35),

Row(
mainAxisAlignment:
MainAxisAlignment.center,
children: [
IconButton(
icon: const Icon(
Icons.remove_circle,
size: 40,
color: AppColors.danger,
),
onPressed: cantidad > 1
? () {
setState(() {
cantidad--;
});
}
: null,
),

Padding(
padding: const EdgeInsets.symmetric(
horizontal: 28,
),
child: Text(
cantidad.toString(),
style: AppTextStyles.titulo,
),
),

IconButton(
icon: const Icon(
Icons.add_circle,
size: 40,
color: AppColors.success,
),
onPressed: cantidad <
widget.producto.stock
? () {
setState(() {
cantidad++;
});
}
: null,
),
],
),

const SizedBox(height: 30),

Text(
"Total",
style: AppTextStyles.descripcion,
),

const SizedBox(height: 8),

Text(
"\$${total.toStringAsFixed(0)}",
style: AppTextStyles.precio,
),

const SizedBox(height: 35),            AppButton(
    texto: "Agregar al carrito",
    icono: Icons.shopping_cart,
    onPressed: widget.producto.stock == 0
        ? null
        : () {
      widget.onAgregar(
        widget.producto.copyWith(
          cantidad: cantidad,
        ),
      );

      Navigator.pop(context);
    },
  ),
],
),
),
);
}

Widget _imagenVacia() {
  return Container(
    width: double.infinity,
    height: 250,
    decoration: BoxDecoration(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(18),
    ),
    child: const Icon(
      Icons.local_grocery_store,
      color: AppColors.primary,
      size: 90,
    ),
  );
}
}