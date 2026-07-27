import 'package:flutter/material.dart';
import '../models/categoria.dart';

class CategoriasProvider extends ChangeNotifier {
  final List<Categoria> _categorias = [
    Categoria(id: "1", nombre: "Frutas", icono: "🍎"),
    Categoria(id: "2", nombre: "Verduras", icono: "🥬"),
    Categoria(id: "3", nombre: "Hojas", icono: "🌿"),
    Categoria(id: "4", nombre: "Tubérculos", icono: "🥔"),
    Categoria(id: "5", nombre: "Cítricos", icono: "🍊"),
    Categoria(id: "6", nombre: "Ofertas", icono: "🔥"),
  ];

  List<Categoria> get categorias => _categorias;
}