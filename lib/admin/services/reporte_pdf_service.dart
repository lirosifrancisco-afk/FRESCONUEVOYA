import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportePdfService {
  static Future<File> generarReporteVentas() async {
    final pdf = pw.Document();

    final pedidos = await FirebaseFirestore.instance
        .collection("pedidos")
        .get();

    double totalVentas = 0;

    final filas = <List<String>>[];

    for (final doc in pedidos.docs) {
      final data = doc.data();

      final fecha = data["fecha"] is Timestamp
          ? DateFormat(
        "dd/MM/yyyy HH:mm",
      ).format((data["fecha"] as Timestamp).toDate())
          : "-";

      final cliente = data["nombre"] ?? "Sin nombre";

      final estado = data["estado"] ?? "-";

      final total = (data["total"] as num?)?.toDouble() ?? 0;

      totalVentas += total;

      filas.add([
        fecha,
        cliente,
        estado,
        "\$ ${total.toStringAsFixed(0)}",
      ]);
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Text(
            "FRESCOYA",
            style: pw.TextStyle(
              fontSize: 28,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 6),

          pw.Text(
            "Reporte General de Ventas",
            style: const pw.TextStyle(
              fontSize: 18,
            ),
          ),

          pw.SizedBox(height: 20),

          pw.Text(
            "Fecha: ${DateFormat("dd/MM/yyyy HH:mm").format(DateTime.now())}",
          ),

          pw.SizedBox(height: 20),

          pw.Text(
            "Cantidad de pedidos: ${pedidos.docs.length}",
          ),

          pw.Text(
            "Ventas totales: \$ ${totalVentas.toStringAsFixed(0)}",
          ),

          pw.SizedBox(height: 20),

          pw.TableHelper.fromTextArray(
            headers: const [
              "Fecha",
              "Cliente",
              "Estado",
              "Total",
            ],
            data: filas,
          ),
        ],
      ),
    );

    final carpeta = await getApplicationDocumentsDirectory();

    final archivo = File(
      "${carpeta.path}/Reporte_FrescoYa.pdf",
    );

    await archivo.writeAsBytes(await pdf.save());

    return archivo;
  }
}