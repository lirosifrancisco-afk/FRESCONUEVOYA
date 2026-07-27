import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/storage_service.dart';

class SelectorImagen extends StatefulWidget {
  final Function(String) onImagenSubida;
  final String? imagenInicial;

  const SelectorImagen({
    super.key,
    required this.onImagenSubida,
    this.imagenInicial,
  });

  @override
  State<SelectorImagen> createState() => _SelectorImagenState();
}

class _SelectorImagenState extends State<SelectorImagen> {
  final StorageService _storage = StorageService();

  XFile? _imagenSeleccionada;
  String? _urlImagen;

  bool _subiendo = false;

  @override
  void initState() {
    super.initState();
    _urlImagen = widget.imagenInicial;
  }

  Future<void> seleccionarImagen() async {
    final imagen = await _storage.seleccionarImagen();

    if (imagen == null) return;

    setState(() {
      _imagenSeleccionada = imagen;
      _subiendo = true;
    });

    final url = await _storage.subirImagen(imagen);

    if (!mounted) return;

    setState(() {
      _subiendo = false;
    });

    if (url != null) {
      setState(() {
        _urlImagen = url;
      });

      widget.onImagenSubida(url);
    }
  }

  Future<void> eliminarImagen() async {
    if (_urlImagen != null && _urlImagen!.isNotEmpty) {
      await _storage.eliminarImagen(_urlImagen!);
    }

    if (!mounted) return;

    setState(() {
      _imagenSeleccionada = null;
      _urlImagen = "";
    });

    widget.onImagenSubida("");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: seleccionarImagen,
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.grey.shade400,
              ),
            ),
            child: _subiendo
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : _urlImagen != null && _urlImagen!.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                _urlImagen!,
                fit: BoxFit.cover,
              ),
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.add_a_photo,
                  size: 50,
                  color: Colors.grey,
                ),
                SizedBox(height: 10),
                Text("Seleccionar imagen"),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (_urlImagen != null && _urlImagen!.isNotEmpty)
          OutlinedButton.icon(
            onPressed: eliminarImagen,
            icon: const Icon(Icons.delete),
            label: const Text("Quitar imagen"),
          ),
      ],
    );
  }
}