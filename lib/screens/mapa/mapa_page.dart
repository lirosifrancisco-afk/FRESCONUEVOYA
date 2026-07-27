import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_text_styles.dart';
import '../../shared/widgets/app_button.dart';

class MapaPage extends StatefulWidget {
  const MapaPage({super.key});

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  // Coordenadas por defecto (Centro de Mendoza Capital para que siempre abra bien ubicado)
  LatLng _ubicacion = const LatLng(-32.889458, -68.845839);

  Marker? _marker;

  String direccion = "Buscando dirección...";

  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _obtenerUbicacion();
  }

  Future<void> _obtenerUbicacion() async {
    bool servicio;
    LocationPermission permiso;

    servicio = await Geolocator.isLocationServiceEnabled();

    if (!servicio) {
      _inicializarMapaConDefault();
      return;
    }

    permiso = await Geolocator.checkPermission();

    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }

    if (permiso == LocationPermission.deniedForever ||
        permiso == LocationPermission.denied) {
      _inicializarMapaConDefault();
      return;
    }

    try {
      Position posicion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _ubicacion = LatLng(
        posicion.latitude,
        posicion.longitude,
      );
    } catch (e) {
      // Si falla el GPS, usamos Mendoza por defecto
    }

    _actualizarMarcador(_ubicacion);
    await _buscarDireccion();

    setState(() {
      cargando = false;
    });
  }

  void _inicializarMapaConDefault() {
    _actualizarMarcador(_ubicacion);
    _buscarDireccion();
    setState(() {
      cargando = false;
    });
  }

  void _actualizarMarcador(LatLng posicion) {
    _ubicacion = posicion;
    _marker = Marker(
      markerId: const MarkerId("cliente"),
      position: posicion,
      draggable: true,
      onDragEnd: (LatLng nuevaPosicion) async {
        _ubicacion = nuevaPosicion;
        await _buscarDireccion();
        setState(() {});
      },
    );
  }

  Future<void> _buscarDireccion() async {
    try {
      List<Placemark> lugares = await placemarkFromCoordinates(
        _ubicacion.latitude,
        _ubicacion.longitude,
      );

      if (lugares.isNotEmpty) {
        Placemark lugar = lugares.first;
        setState(() {
          direccion =
          "${lugar.street ?? 'Calle sin nombre'}, ${lugar.locality ?? 'Mendoza'}";
        });
      }
    } catch (e) {
      setState(() {
        direccion = "Ubicación seleccionada en el mapa";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Seleccionar ubicación"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _ubicacion,
                zoom: 15,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true, // Habilitamos los controles de zoom
              scrollGesturesEnabled: true, // Habilitamos movernos por el mapa
              zoomGesturesEnabled: true, // Habilitamos hacer zoom con los dedos
              rotateGesturesEnabled: true,
              tiltGesturesEnabled: true,
              markers: {
                if (_marker != null) _marker!,
              },
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onTap: (LatLng posicion) async {
                // Al hacer clic en cualquier parte del mapa, movemos el marcador allí
                setState(() {
                  _actualizarMarcador(posicion);
                });
                await _buscarDireccion();
              },
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black12,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dirección seleccionada",
                  style: AppTextStyles.subtitulo,
                ),
                const SizedBox(height: 10),
                Text(
                  direccion,
                  style: AppTextStyles.descripcion,
                ),
                const SizedBox(height: 20),
                AppButton(
                  texto: "Usar esta dirección",
                  icono: Icons.check_circle,
                  onPressed: () {
                    Navigator.pop(
                      context,
                      {
                        "direccion": direccion,
                        "latitud": _ubicacion.latitude,
                        "longitud": _ubicacion.longitude,
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}