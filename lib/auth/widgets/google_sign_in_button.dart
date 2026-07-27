import 'package:flutter/material.dart';

/// Botón reutilizable "Continuar con Google".
///
/// Se muestra como un botón blanco con borde gris y el logo de Google.
/// Mientras [cargando] es `true` muestra un indicador de progreso.
class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool cargando;
  final String texto;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.cargando = false,
    this.texto = "Continuar con Google",
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: cargando ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          side: BorderSide(color: Colors.grey.shade400),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: cargando
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Image.network(
                'https://developers.google.com/identity/images/g-logo.png',
                width: 22,
                height: 22,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.login,
                  color: Colors.red,
                  size: 22,
                ),
              ),
        label: Text(
          texto,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
