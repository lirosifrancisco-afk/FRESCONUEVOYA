import 'package:flutter/material.dart';

class PedidoExitosoPage extends StatelessWidget {
  final String numeroPedido;

  const PedidoExitosoPage({
    super.key,
    required this.numeroPedido,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Pedido confirmado"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 55,
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 60,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "¡Pedido realizado con éxito!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                "Número de pedido:\n$numeroPedido",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Estamos preparando tu pedido.\nTe avisaremos cuando esté listo.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.home),
                  label: const Text(
                    "Volver al inicio",
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}