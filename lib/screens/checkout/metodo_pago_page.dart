import 'package:flutter/material.dart';

class MetodoPagoPage extends StatefulWidget {
  final Map<String, dynamic> datos;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const MetodoPagoPage({
    super.key,
    required this.datos,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<MetodoPagoPage> createState() => _MetodoPagoPageState();
}

class _MetodoPagoPageState extends State<MetodoPagoPage> {
  @override
  Widget build(BuildContext context) {
    String metodo = widget.datos["metodoPago"] ?? "efectivo";

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "¿Cómo querés pagar?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 25),

          Card(
            child: RadioListTile<String>(
              value: "efectivo",
              groupValue: metodo,
              title: const Text("💵 Efectivo"),
              subtitle: const Text("Pagás al recibir el pedido"),
              onChanged: (value) {
                setState(() {
                  widget.datos["metodoPago"] = value!;
                });
              },
            ),
          ),

          Card(
            child: RadioListTile<String>(
              value: "transferencia",
              groupValue: metodo,
              title: const Text("🏦 Transferencia"),
              subtitle: const Text("Alias o CBU"),
              onChanged: (value) {
                setState(() {
                  widget.datos["metodoPago"] = value!;
                });
              },
            ),
          ),

          Card(
            child: RadioListTile<String>(
              value: "mercadopago",
              groupValue: metodo,
              title: const Text("💳 Mercado Pago"),
              subtitle: const Text("Pago online"),
              onChanged: (value) {
                setState(() {
                  widget.datos["metodoPago"] = value!;
                });
              },
            ),
          ),

          const Spacer(),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Volver"),
                  onPressed: widget.onBack,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text("Continuar"),
                  onPressed: widget.onNext,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}