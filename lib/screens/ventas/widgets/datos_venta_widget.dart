import 'package:flutter/material.dart';

import '../../../providers/venta_actual_provider.dart';

class DatosVentaWidget extends StatelessWidget {
  final VentaActualProvider venta;

  final TextEditingController descuentoController;
  final TextEditingController observacionesController;

  const DatosVentaWidget({
    super.key,
    required this.venta,
    required this.descuentoController,
    required this.observacionesController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: const [
                Icon(
                  Icons.receipt_long,
                  color: Colors.green,
                ),
                SizedBox(width: 8),
                Text(
                  "Datos de la venta",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            TextFormField(
              initialValue: venta.cliente,
              decoration: const InputDecoration(
                labelText: "Cliente",
                prefixIcon: Icon(Icons.person),
              ),
              onChanged: venta.cambiarCliente,
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<MetodoPago>(
              value: venta.metodoPago,
              decoration: const InputDecoration(
                labelText: "Método de pago",
                prefixIcon: Icon(Icons.payments),
              ),
              items: MetodoPago.values.map((metodo) {
                return DropdownMenuItem(
                  value: metodo,
                  child: Text(_nombreMetodo(metodo)),
                );
              }).toList(),
              onChanged: (metodo) {
                if (metodo != null) {
                  venta.cambiarMetodoPago(metodo);
                }
              },
            ),

            const SizedBox(height: 15),

            TextField(
              controller: descuentoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Descuento",
                prefixIcon: Icon(Icons.percent),
              ),
              onChanged: (value) {
                venta.cambiarDescuento(
                  double.tryParse(value) ?? 0,
                );
              },
            ),

            const SizedBox(height: 15),

            TextField(
              controller: observacionesController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Observaciones",
                prefixIcon: Icon(Icons.notes),
              ),
              onChanged: venta.cambiarObservaciones,
            ),
          ],
        ),
      ),
    );
  }

  String _nombreMetodo(MetodoPago metodo) {
    switch (metodo) {
      case MetodoPago.efectivo:
        return "Efectivo";
      case MetodoPago.transferencia:
        return "Transferencia";
      case MetodoPago.mercadoPago:
        return "Mercado Pago";
      case MetodoPago.tarjeta:
        return "Tarjeta";
    }
  }
}