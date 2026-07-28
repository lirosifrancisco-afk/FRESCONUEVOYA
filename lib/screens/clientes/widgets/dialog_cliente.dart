import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/cliente.dart';
import '../../../providers/clientes_provider.dart';

class DialogCliente extends StatefulWidget {
  final Cliente? cliente;

  const DialogCliente({
    super.key,
    this.cliente,
  });

  @override
  State<DialogCliente> createState() => _DialogClienteState();
}

class _DialogClienteState extends State<DialogCliente> {
  late final TextEditingController nombreController;
  late final TextEditingController telefonoController;
  late final TextEditingController direccionController;
  late final TextEditingController observacionesController;
  late final TextEditingController saldoController;

  @override
  void initState() {
    super.initState();

    nombreController = TextEditingController(
      text: widget.cliente?.nombre ?? '',
    );

    telefonoController = TextEditingController(
      text: widget.cliente?.telefono ?? '',
    );

    direccionController = TextEditingController(
      text: widget.cliente?.direccion ?? '',
    );

    observacionesController = TextEditingController(
      text: widget.cliente?.observaciones ?? '',
    );

    saldoController = TextEditingController(
      text: (widget.cliente?.saldo ?? 0).toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    nombreController.dispose();
    telefonoController.dispose();
    direccionController.dispose();
    observacionesController.dispose();
    saldoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ClientesProvider>();

    return AlertDialog(
      title: Text(
        widget.cliente == null
            ? "Nuevo cliente"
            : "Editar cliente",
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: "Nombre",
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: telefonoController,
              decoration: const InputDecoration(
                labelText: "Teléfono",
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: direccionController,
              decoration: const InputDecoration(
                labelText: "Dirección",
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: observacionesController,
              decoration: const InputDecoration(
                labelText: "Observaciones",
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: saldoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Saldo",
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        FilledButton(
          onPressed: () async {
            final cliente = Cliente(
              id: widget.cliente?.id ?? '',
              nombre: nombreController.text.trim(),
              telefono: telefonoController.text.trim(),
              direccion: direccionController.text.trim(),
              observaciones: observacionesController.text.trim(),
              saldo: double.tryParse(saldoController.text) ?? 0,
            );

            if (widget.cliente == null) {
              await provider.agregarCliente(cliente);
            } else {
              await provider.actualizarCliente(cliente);
            }

            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          child: Text(
            widget.cliente == null ? "Guardar" : "Actualizar",
          ),
        ),
      ],
    );
  }
}