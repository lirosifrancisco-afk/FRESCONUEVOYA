import 'package:flutter/material.dart';

import '../../shared/theme/app_text_styles.dart';
import '../../shared/widgets/app_button.dart';
import '../mapa/mapa_page.dart';

class DireccionPage extends StatefulWidget {
  final Map<String, dynamic> datos;
  final VoidCallback onNext;

  const DireccionPage({
    super.key,
    required this.datos,
    required this.onNext,
  });

  @override
  State<DireccionPage> createState() => _DireccionPageState();
}

class _DireccionPageState extends State<DireccionPage> {
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _direccionController = TextEditingController();

  double? latitud;
  double? longitud;

  bool get _puedeAvanzar =>
      _nombreController.text.trim().isNotEmpty &&
          _telefonoController.text.trim().isNotEmpty &&
          _direccionController.text.trim().isNotEmpty;

  Future<void> _abrirMapa() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MapaPage(),
      ),
    );

    if (resultado != null) {
      setState(() {
        _direccionController.text = resultado["direccion"] ?? "";
        latitud = resultado["latitud"];
        longitud = resultado["longitud"];
      });
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "¿A quién entregamos?",
            style: AppTextStyles.titulo,
          ),

          const SizedBox(height: 18),

          TextField(
            controller: _nombreController,
            textCapitalization: TextCapitalization.words,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: "Nombre completo *",
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: _telefonoController,
            keyboardType: TextInputType.phone,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: "Teléfono / WhatsApp *",
              prefixIcon: const Icon(Icons.phone_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 28),

          Text(
            "¿Dónde recibís tu pedido?",
            style: AppTextStyles.titulo,
          ),

          const SizedBox(height: 18),

          TextField(
            controller: _direccionController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: "Dirección *",
              helperText: "Escribí la dirección o seleccionála en el mapa.",
              prefixIcon: const Icon(Icons.home_outlined),
              suffixIcon: IconButton(
                icon: const Icon(Icons.map_outlined),
                onPressed: _abrirMapa,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          if (latitud != null && longitud != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Ubicación seleccionada correctamente",
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: AppButton(
              texto: "Continuar",
              onPressed: _puedeAvanzar
                  ? () {
                widget.datos["nombre"] =
                    _nombreController.text.trim();
                widget.datos["telefono"] =
                    _telefonoController.text.trim();
                widget.datos["direccion"] =
                    _direccionController.text.trim();
                widget.datos["latitud"] = latitud;
                widget.datos["longitud"] = longitud;

                widget.onNext();
              }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}