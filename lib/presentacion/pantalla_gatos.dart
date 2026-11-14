import 'package:flutter/material.dart';

// La API de Cataas no necesita API key.
// Solo armamos una URL y se la damos a Image.network.
//   Gato al azar:            https://cataas.com/cat
//   Gato con texto:          https://cataas.com/cat/says/Hola
//   Con filtro y color:      https://cataas.com/cat/says/Hola?filter=mono&fontColor=white

// Reto 2: Memes de gatos con filtros.
class PantallaGatos extends StatefulWidget {
  const PantallaGatos({super.key});

  @override
  State<PantallaGatos> createState() => _PantallaGatosState();
}

class _PantallaGatosState extends State<PantallaGatos> {
  final TextEditingController controladorTexto = TextEditingController();

  // Filtros que acepta Cataas ('' = sin filtro).
  final Map<String, String> filtros = {
    'Sin filtro': '',
    'Blanco y negro': 'mono',
    'Borroso': 'blur',
    'Negativo': 'negate',
  };

  final Map<String, String> colores = {
    'Blanco': 'white',
    'Amarillo': 'yellow',
    'Rojo': 'red',
    'Negro': 'black',
  };

  String filtroElegido = 'Sin filtro';
  String colorElegido = 'Blanco';
  String urlImagen = 'https://cataas.com/cat';

  // Construye la URL dinámica con el texto del TextField.
  void generarMeme() {
    final texto = controladorTexto.text.trim();
    String url = 'https://cataas.com/cat';

    if (texto.isNotEmpty) {
      // encodeComponent convierte espacios y acentos para que la URL funcione.
      url += '/says/${Uri.encodeComponent(texto)}';
    }

    // Parámetros de la URL
    url += '?fontSize=40&fontColor=${colores[colorElegido]}';
    final filtro = filtros[filtroElegido]!;
    if (filtro.isNotEmpty) {
      url += '&filter=$filtro';
    }
    // Un número distinto cada vez para que salga otro gato y no se repita la imagen.
    url += '&t=${DateTime.now().millisecondsSinceEpoch}';

    setState(() {
      urlImagen = url;
    });
  }

  @override
  void dispose() {
    controladorTexto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Memes de gatos')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Imagen del gato
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              urlImagen,
              key: ValueKey(urlImagen),
              height: 320,
              fit: BoxFit.contain,
              // Mientras carga, muestra un círculo
              loadingBuilder: (context, child, progreso) {
                if (progreso == null) return child;
                return const SizedBox(
                  height: 320,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stack) => const SizedBox(
                height: 320,
                child: Center(child: Text('No se pudo cargar el gato 😿')),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controladorTexto,
            decoration: const InputDecoration(
              labelText: 'Escribe tu frase',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => generarMeme(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: filtroElegido,
                  decoration: const InputDecoration(labelText: 'Filtro'),
                  items: filtros.keys
                      .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                      .toList(),
                  onChanged: (valor) =>
                      setState(() => filtroElegido = valor!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: colorElegido,
                  decoration:
                      const InputDecoration(labelText: 'Color de letra'),
                  items: colores.keys
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (valor) => setState(() => colorElegido = valor!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: generarMeme,
            icon: const Icon(Icons.pets),
            label: const Text('Generar meme'),
          ),
          const SizedBox(height: 8),
          // Muestra la URL para ver cómo cambia con los parámetros
          SelectableText(
            urlImagen,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
