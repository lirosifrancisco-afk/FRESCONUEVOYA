import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class VentasChart extends StatelessWidget {
  final List<double> ventas;

  const VentasChart({
    super.key,
    required this.ventas,
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
              "Ventas por mes",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: true),

                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),

                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),

                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const meses = [
                            "E",
                            "F",
                            "M",
                            "A",
                            "M",
                            "J",
                            "J",
                            "A",
                            "S",
                            "O",
                            "N",
                            "D",
                          ];

                          if (value.toInt() >= meses.length) {
                            return const SizedBox();
                          }

                          return Text(meses[value.toInt()]);
                        },
                      ),
                    ),

                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),

                  barGroups: List.generate(
                    ventas.length,
                        (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: ventas[index],
                          width: 18,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}