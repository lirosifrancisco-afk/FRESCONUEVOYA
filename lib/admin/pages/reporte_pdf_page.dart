import 'dart:io';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../services/reporte_pdf_service.dart';

class ReportePdfPage extends StatefulWidget {
  const ReportePdfPage({super.key});

  @override
  State<ReportePdfPage> createState() => _ReportePdfPageState();
}

class _ReportePdfPageState extends State<ReportePdfPage> {
  File? _archivo;
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _generarPdf();
  }

  Future<void> _generarPdf() async {
    try {
      final pdf = await ReportePdfService.generarReporteVentas();

      if (!mounted) return;

      setState(() {
        _archivo = pdf;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Reporte PDF"),
        ),
        body: Center(
          child: Text(_error!),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reporte PDF"),
      ),
      body: PdfPreview(
        build: (format) async => _archivo!.readAsBytes(),
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        allowPrinting: true,
        allowSharing: true,
      ),
    );
  }
}