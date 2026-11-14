import 'package:flutter/material.dart';

import '../datos/servicios.dart';
import '../dominio/modelos.dart';

// Reto 4: Convertidor de cripto.
class PantallaCripto extends StatefulWidget {
  const PantallaCripto({super.key});

  @override
  State<PantallaCripto> createState() => _PantallaCriptoState();
}

class _PantallaCriptoState extends State<PantallaCripto> {
  final TextEditingController controladorMonto =
      TextEditingController(text: '100');

  late Future<List<Cripto>> futuroPrecios;
  double monto = 100;

  @override
  void initState() {
    super.initState();
    futuroPrecios = ServicioCripto.obtenerPrecios();
  }

  // Vuelve a pedir los precios (botón de refrescar).
  void recargar() {
    setState(() {
      futuroPrecios = ServicioCripto.obtenerPrecios();
    });
  }

  // Se llama cada vez que el usuario escribe en el campo.
  void cambiarMonto(String texto) {
    setState(() {
      // tryParse devuelve null si no es número; en ese caso usamos 0
      monto = double.tryParse(texto.replaceAll(',', '.')) ?? 0;
    });
  }

  @override
  void dispose() {
    controladorMonto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Convertidor de cripto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar precios',
            onPressed: recargar,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: controladorMonto,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Monto en dólares (USD)',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
              onChanged: cambiarMonto,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Cripto>>(
              future: futuroPrecios,
              builder: (context, snapshot) {
                // 1. Cargando
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                // 2. Error
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error
                        .toString()
                        .replaceFirst('Exception: ', '')),
                  );
                }
                // 3. Datos listos
                final criptos = snapshot.data!;
                return ListView.builder(
                  itemCount: criptos.length,
                  itemBuilder: (context, i) {
                    final c = criptos[i];
                    // Lo que compras = monto / precio
                    final cantidad = monto / c.precio;
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(child: Text(c.simbolo[0])),
                        title: Text('${c.nombre} (${c.simbolo})'),
                        subtitle: Text(
                            'Precio: \$${c.precio.toStringAsFixed(2)} USD'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Comprarías',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                            Text(
                              '${cantidad.toStringAsFixed(6)} ${c.simbolo}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
