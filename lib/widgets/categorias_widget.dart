import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categorias_provider.dart';

class CategoriasWidget extends StatelessWidget {
  final String categoriaSeleccionada;
  final Function(String) onCategoriaSeleccionada;

  const CategoriasWidget({
    super.key,
    required this.categoriaSeleccionada,
    required this.onCategoriaSeleccionada,
  });

  @override
  Widget build(BuildContext context) {
    final categorias =
        context.watch<CategoriasProvider>().categorias;

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categorias.length,
        itemBuilder: (context, index) {
          final categoria = categorias[index];

          final seleccionada =
              categoria.nombre == categoriaSeleccionada;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: ChoiceChip(
              label: Text(
                "${categoria.icono} ${categoria.nombre}",
              ),
              selected: seleccionada,
              onSelected: (_) {
                onCategoriaSeleccionada(categoria.nombre);
              },
            ),
          );
        },
      ),
    );
  }
}