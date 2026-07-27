import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = FirebaseAuth.instance.currentUser;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "¡Hola! 👋",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 4),
        Text(
          usuario?.email ?? "",
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}