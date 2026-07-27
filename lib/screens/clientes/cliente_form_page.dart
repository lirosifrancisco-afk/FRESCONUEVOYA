import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cliente.dart';
import '../../providers/clientes_provider.dart';

class ClienteFormPage extends StatefulWidget {
  final Cliente? cliente;

  const ClienteFormPage({
    super.key,
    this.cliente,
  });

  @override
  State<ClienteFormPage> createState() => _ClienteFormPageState();
}

class _ClienteFormPageState extends State<ClienteFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nombreController;
  late TextEditingController telefonoController;
  late TextEditingController direccionController;

  @override
  void initState() {
    super.initState();

    nombreController = TextEditingController(
      text: widget.cliente?.nombre ?? "",
    );

    telefonoController = TextEditingController(
      text: widget.cliente?.telefono ?? "",
    );

    direccionController = TextEditingController(
      text: widget.cliente?.direccion ?? "",
    );
  }

  @override
  void dispose() {
    nombreController.dispose();
    telefonoController.dispose();
    direccionController.dispose();
    super.dispose();
  }

  Future<void> guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final provider =
    Provider.of<ClientesProvider>(context, listen: false);

    if (widget.cliente == null) {
      await provider.agregarCliente(
        nombre: nombreController.text.trim(),
        telefono: telefonoController.text.trim(),
        direccion: direccionController.text.trim(),
      );
    } else {
      await provider.editarCliente(
        Cliente(
          id: widget.cliente!.id,
          nombre: nombreController.text.trim(),
          telefono: telefonoController.text.trim(),
          direccion: direccionController.text.trim(),
          activo: widget.cliente!.activo,
        ),
      );
    }

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.cliente != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editando ? "Editar Cliente" : "Nuevo Cliente",
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: "Nombre",
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Ingrese el nombre";
                }
                return null;
              },
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: telefonoController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Teléfono",
                prefixIcon: Icon(Icons.phone),
              ),
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: direccionController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Dirección",
                prefixIcon: Icon(Icons.location_on),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(
                  editando
                      ? "GUARDAR CAMBIOS"
                      : "CREAR CLIENTE",
                ),
                onPressed: guardar,
              ),
            ),
          ],
        ),
      ),
    );
  }
}