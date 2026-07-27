import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String titulo;
  final Future<dynamic> future;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.color,
    required this.titulo,
    required this.future,
  });

  String _formatear(dynamic valor) {
    if (valor == null) return "-";

    if (valor is double) {
      return valor.toStringAsFixed(0);
    }

    if (valor is int) {
      return valor.toString();
    }

    return valor.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(.15),
              child: Icon(
                icon,
                color: color,
                size: 30,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: FutureBuilder<dynamic>(
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Text(
                      "Error",
                      style: TextStyle(color: Colors.red),
                    );
                  }

                  return Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        _formatear(snapshot.data),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}