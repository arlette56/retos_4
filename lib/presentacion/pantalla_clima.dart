import 'package:flutter/material.dart';

import '../datos/servicios.dart';
import '../dominio/modelos.dart';

// Reto 3: Clima minimalista.
class PantallaClima extends StatefulWidget {
  const PantallaClima({super.key});

  @override
  State<PantallaClima> createState() => _PantallaClimaState();
}

class _PantallaClimaState extends State<PantallaClima> {
  final TextEditingController controladorCiudad =
      TextEditingController(text: 'Dolores Hidalgo');

  Clima? clima;
  bool cargando = false;
  String? error;

  @override
  void initState() {
    super.initState();
    buscar();
  }

  Future<void> buscar() async {
    setState(() {
      cargando = true;
      error = null;
    });
    try {
      clima = await ServicioClima.obtenerClima(controladorCiudad.text.trim());
    } catch (e) {
      clima = null;
      error = e.toString().replaceFirst('Exception: ', '');
    }
    if (!mounted) return;
    setState(() => cargando = false);
  }

  @override
  void dispose() {
    controladorCiudad.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clima minimalista')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controladorCiudad,
                    decoration: const InputDecoration(
                      labelText: 'Ciudad',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => buscar(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: buscar,
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(child: Center(child: contenido())),
          ],
        ),
      ),
    );
  }

  Widget contenido() {
    if (cargando) {
      return const CircularProgressIndicator();
    }
    if (error != null) {
      return Text(error!, textAlign: TextAlign.center);
    }
    if (clima == null) {
      return const Text('Escribe una ciudad');
    }

    final c = clima!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(c.ciudad,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        Image.network('https://openweathermap.org/img/wn/${c.icono}@4x.png',
            width: 140),
        Text('${c.temperatura.round()}°C',
            style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w300)),
        Text(
          // Primera letra en mayúscula: "cielo claro" -> "Cielo claro"
          c.descripcion[0].toUpperCase() + c.descripcion.substring(1),
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            dato(Icons.thermostat, 'Sensación', '${c.sensacion.round()}°C'),
            dato(Icons.water_drop, 'Humedad', '${c.humedad}%'),
            // La API da m/s; multiplicamos por 3.6 para km/h
            dato(Icons.air, 'Viento', '${(c.viento * 3.6).round()} km/h'),
          ],
        ),
      ],
    );
  }

  Widget dato(IconData icono, String titulo, String valor) {
    return Column(
      children: [
        Icon(icono, color: Colors.indigo),
        Text(titulo, style: const TextStyle(color: Colors.grey)),
        Text(valor,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
