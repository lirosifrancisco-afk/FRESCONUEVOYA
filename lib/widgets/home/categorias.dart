import 'package:flutter/material.dart';

class Categorias extends StatelessWidget {
  const Categorias({super.key});

  Widget categoria(String emoji, String titulo) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        const SizedBox(height: 6),
        Text(titulo),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          categoria("🥬", "Verduras"),
          categoria("🍎", "Frutas"),
          categoria("🥔", "Tubérculos"),
          categoria("🔥", "Ofertas"),
        ],
      ),
    );
  }
}