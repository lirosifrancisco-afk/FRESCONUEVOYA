import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/producto.dart';
import '../../providers/productos_provider.dart';
import '../../providers/venta_actual_provider.dart';

import 'widgets/buscador_productos_widget.dart';
import 'widgets/datos_venta_widget.dart';
import 'widgets/formulario_producto_widget.dart';
import 'widgets/lista_venta_widget.dart';
import 'widgets/resumen_venta_widget.dart';

class NuevaVentaPage extends StatefulWidget {
  const NuevaVentaPage({super.key});

  @override
  State<NuevaVentaPage> createState() => _NuevaVentaPageState();
}

class _NuevaVentaPageState extends State<NuevaVentaPage> {
final buscarController = TextEditingController();
final cantidadController = TextEditingController(text: "1");
final precioController = TextEditingController();

final descuentoController = TextEditingController();
final observacionesController = TextEditingController();

Producto? productoSeleccionado;

@override
void initState() {
super.initState();

buscarController.addListener(() {
setState(() {});
});
}

@override
void dispose() {
buscarController.dispose();
cantidadController.dispose();
precioController.dispose();
descuentoController.dispose();
observacionesController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
final productosProvider = context.watch<ProductosProvider>();
final ventaProvider = context.watch<VentaActualProvider>();

final productos =
productosProvider.buscar(buscarController.text);

return Scaffold(
appBar: AppBar(
title: const Text("Nueva Venta"),
),
body: SafeArea(
child: Column(
children: [
DatosVentaWidget(
venta: ventaProvider,
descuentoController: descuentoController,
observacionesController: observacionesController,
),            if (productoSeleccionado == null)
    Expanded(
      child: BuscadorProductosWidget(
        controller: buscarController,
        productos: productos,
        onSeleccionar: (producto) {
          setState(() {
            productoSeleccionado = producto;
            cantidadController.text = "1";
            precioController.text =
                producto.precio.toStringAsFixed(0);
            buscarController.clear();
          });
        },
      ),
    ),

  if (productoSeleccionado != null)
    FormularioProductoWidget(
      producto: productoSeleccionado!,
      cantidadController: cantidadController,
      precioController: precioController,
      onAgregar: () {
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
          cantidadController.text = "1";
          precioController.clear();
          buscarController.clear();
        });
      },
      onCancelar: () {
        setState(() {
          productoSeleccionado = null;
          cantidadController.text = "1";
          precioController.clear();
          buscarController.clear();
        });
      },
    ),

  const Divider(height: 1),

  Expanded(
    child: ListaVentaWidget(
      venta: ventaProvider,
    ),
  ),

  ResumenVentaWidget(
    venta: ventaProvider,
  ),
],
),
),
);
}
}