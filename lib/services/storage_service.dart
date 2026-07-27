import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  /// Seleccionar una imagen desde la galería
  Future<XFile?> seleccionarImagen() async {
    try {
      return await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
    } catch (e) {
      debugPrint("Error seleccionando imagen: $e");
      return null;
    }
  }

  /// Subir imagen y devolver la URL
  Future<String?> subirImagen(XFile imagen) async {
    try {
      final nombre =
          "${const Uuid().v4()}.${imagen.name.split('.').last}";

      final referencia = _storage
          .ref()
          .child("productos")
          .child(nombre);

      UploadTask tarea;

      if (kIsWeb) {
        final bytes = await imagen.readAsBytes();

        tarea = referencia.putData(
          bytes,
          SettableMetadata(
            contentType: "image/jpeg",
          ),
        );
      } else {
        tarea = referencia.putFile(File(imagen.path));
      }

      final snapshot = await tarea;

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint("Error subiendo imagen: $e");
      return null;
    }
  }

  /// Eliminar una imagen existente
  Future<void> eliminarImagen(String url) async {
    if (url.isEmpty) return;

    try {
      await _storage.refFromURL(url).delete();
    } catch (e) {
      debugPrint("No se pudo eliminar la imagen: $e");
    }
  }
}