import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  static const titulo = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  static const subtitulo = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  static const cuerpo = TextStyle(
    fontSize: 16,
    color: AppColors.text,
  );

  static const descripcion = TextStyle(
    fontSize: 14,
    color: AppColors.subtitle,
  );

  static const precio = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.success,
  );

  static const boton = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}