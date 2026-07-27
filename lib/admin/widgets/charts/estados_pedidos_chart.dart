import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class EstadosPedidosChart extends StatelessWidget {
  final int pendientes;
  final int preparando;
  final int entregados;
  final int cancelados;

  const EstadosPedidosChart({
    super.key,
    required this.pendientes,
    required this.preparando,
    required this.entregados,
    required this.cancelados,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Estado de los pedidos",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 260,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 45,
                  sectionsSpace: 3,
                  sections: [
                    PieChartSectionData(
                      value: pendientes.toDouble(),
                      color: Colors.orange,
                      title: "$pendientes",
                      radius: 65,
                    ),
                    PieChartSectionData(
                      value: preparando.toDouble(),
                      color: Colors.blue,
                      title: "$preparando",
                      radius: 65,
                    ),
                    PieChartSectionData(
                      value: entregados.toDouble(),
                      color: Colors.green,
                      title: "$entregados",
                      radius: 65,
                    ),
                    PieChartSectionData(
                      value: cancelados.toDouble(),
                      color: Colors.red,
                      title: "$cancelados",
                      radius: 65,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: const [
                _Leyenda(Colors.orange, "Pendientes"),
                _Leyenda(Colors.blue, "Preparando"),
                _Leyenda(Colors.green, "Entregados"),
                _Leyenda(Colors.red, "Cancelados"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Leyenda extends StatelessWidget {
  final Color color;
  final String texto;

  const _Leyenda(this.color, this.texto);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(texto),
      ],
    );
  }
}