import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/carrito_provider.dart';
import '../../services/flete_service.dart';
import '../../services/mercadopago_service.dart';
import '../../services/pedidos_service.dart';
import '../../shared/theme/app_colors.dart';
import 'pedido_exitoso_page.dart';

class ResumenPage extends StatelessWidget {
  final Map<String, dynamic> datos;
  final VoidCallback onBack;

  const ResumenPage({
    super.key,
    required this.datos,
    required this.onBack,
  });

  String _labelMetodoPago(String metodo) {
    switch (metodo) {
      case 'efectivo':
        return 'Efectivo';
      case 'transferencia':
        return 'Transferencia';
      case 'mercadopago':
        return 'Mercado Pago';
      default:
        return metodo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final carrito = context.watch<CarritoProvider>();

    final tipoEntrega = (datos['tipoEntrega'] as String?) ?? 'delivery';

    final double costoFlete = tipoEntrega == 'retiro'
        ? 0
        : (datos['costoFlete'] as num?)?.toDouble() ??
            FleteService.calcularCostoFlete(
              datos['latitud'],
              datos['longitud'],
            );

    final double distanciaKm = tipoEntrega == 'retiro'
        ? 0
        : (datos['distanciaKm'] as num?)?.toDouble() ??
            FleteService.distanciaRedondeada(
              datos['latitud'],
              datos['longitud'],
            );

    final double totalFinal = carrito.total + costoFlete;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen del pedido',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(datos['nombre'] ?? ''),
              subtitle: Text(datos['telefono'] ?? ''),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(
                tipoEntrega == 'retiro'
                    ? 'Retira en el local'
                    : (datos['direccion'] ?? ''),
              ),
              subtitle: Text(
                tipoEntrega == 'retiro'
                    ? 'Sin costo de envío'
                    : 'Distancia estimada: ${distanciaKm.toStringAsFixed(2)} km',
              ),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.payment),
              title: Text(
                _labelMetodoPago((datos['metodoPago'] as String?) ?? 'efectivo'),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Productos',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              itemCount: carrito.productos.length,
              itemBuilder: (context, index) {
                final p = carrito.productos[index];

                return ListTile(
                  title: Text(p.nombre),
                  subtitle: Text(
                    '${p.cantidad} x \$${p.precio.toStringAsFixed(0)}',
                  ),
                  trailing: Text(
                    '\$${p.total.toStringAsFixed(0)}',
                  ),
                );
              },
            ),
          ),

          const Divider(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal productos:'),
              Text('\$${carrito.total.toStringAsFixed(0)}'),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tipoEntrega == 'retiro'
                  ? 'Costo de flete:'
                  : 'Costo de flete (${distanciaKm.toStringAsFixed(2)} km):'),
              Text('\$${costoFlete.toStringAsFixed(0)}'),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TOTAL FINAL',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Text(
                '\$${totalFinal.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Volver'),
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Confirmar'),
                  onPressed: () async {
                    final metodoPago =
                        datos['metodoPago'] as String? ?? 'efectivo';
                    final esMercadoPago = metodoPago == 'mercadopago';

                    try {
                      final id = await PedidosService().guardarPedido(
                        productos: carrito.productos,
                        total: totalFinal,
                        nombre: datos['nombre'] ?? '',
                        telefono: datos['telefono'] ?? '',
                        direccion: datos['direccion'] ?? '',
                        metodoPago: metodoPago,
                        latitud: datos['latitud'],
                        longitud: datos['longitud'],
                        costoFlete: costoFlete,
                        distanciaKm: distanciaKm,
                        tipoEntrega: tipoEntrega,
                        referencia: datos['referencia'] ?? '',
                        estado:
                            esMercadoPago ? 'pendiente_pago' : 'Pendiente',
                      );

                      if (esMercadoPago) {
                        final items = <Map<String, dynamic>>[
                          for (final p in carrito.productos)
                            {
                              'title': p.nombre,
                              'quantity': p.cantidad,
                              'unit_price': p.precio,
                            },
                        ];

                        if (costoFlete > 0) {
                          items.add({
                            'title': 'Costo de envío',
                            'quantity': 1,
                            'unit_price': costoFlete,
                          });
                        }

                        final email =
                            FirebaseAuth.instance.currentUser?.email ?? '';

                        final mp = MercadoPagoService();
                        final initPoint = await mp.crearPreferencia(
                          items: items,
                          externalReference: id,
                          payerEmail: email,
                        );

                        await mp.abrirCheckout(initPoint);
                      }

                      carrito.vaciarCarrito();

                      if (!context.mounted) return;

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PedidoExitosoPage(
                            numeroPedido: id,
                          ),
                        ),
                      );
                    } catch (e) {
                      if (!context.mounted) return;

                      final texto = e.toString().replaceFirst('Exception: ', '');

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(texto),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
