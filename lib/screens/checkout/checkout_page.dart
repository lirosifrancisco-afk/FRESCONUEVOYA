import 'package:flutter/material.dart';

import 'direccion_page.dart';
import 'metodo_pago_page.dart';
import 'resumen_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final PageController _pageController = PageController();

  int _paginaActual = 0;

  final Map<String, dynamic> datosPedido = {
    "nombre": "",
    "telefono": "",
    "direccion": "",
    "referencia": "",
    "tipoEntrega": "delivery",
    "metodoPago": "efectivo",
  };

  void siguientePagina() {
    if (_paginaActual < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      setState(() {
        _paginaActual++;
      });
    }
  }

  void paginaAnterior() {
    if (_paginaActual > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      setState(() {
        _paginaActual--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finalizar compra"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          StepperHeader(
            pagina: _paginaActual,
          ),

          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                DireccionPage(
                  datos: datosPedido,
                  onNext: siguientePagina,
                ),
                MetodoPagoPage(
                  datos: datosPedido,
                  onBack: paginaAnterior,
                  onNext: siguientePagina,
                ),
                ResumenPage(
                  datos: datosPedido,
                  onBack: paginaAnterior,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StepperHeader extends StatelessWidget {
  final int pagina;

  const StepperHeader({
    super.key,
    required this.pagina,
  });

  Widget circulo(
      int numero,
      String texto,
      bool activo,
      ) {
    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor:
          activo ? Colors.green : Colors.grey.shade300,
          child: Text(
            numero.toString(),
            style: TextStyle(
              color: activo ? Colors.white : Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(texto),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          circulo(1, "Dirección", pagina >= 0),
          circulo(2, "Pago", pagina >= 1),
          circulo(3, "Resumen", pagina >= 2),
        ],
      ),
    );
  }
}