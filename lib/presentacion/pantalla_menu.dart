import 'package:flutter/material.dart';

import 'pantalla_clima.dart';
import 'pantalla_cripto.dart';
import 'pantalla_gatos.dart';
import 'pantalla_peliculas.dart';

// Pantalla de inicio: un botón por cada reto.
class PantallaMenu extends StatelessWidget {
  const PantallaMenu({super.key});

  // Abre la pantalla que le pasemos.
  void abrir(BuildContext context, Widget pantalla) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => pantalla),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Los Cuatro Retos')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Text('🚀', style: TextStyle(fontSize: 30)),
              title: const Text('Reto 1: Películas'),
              subtitle: const Text('Recomendador según tu estado de ánimo'),
              onTap: () => abrir(context, const PantallaPeliculas()),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Text('🐱', style: TextStyle(fontSize: 30)),
              title: const Text('Reto 2: Memes de gatos'),
              subtitle: const Text('Escribe una frase y ponla sobre un gato'),
              onTap: () => abrir(context, const PantallaGatos()),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Text('🌦️', style: TextStyle(fontSize: 30)),
              title: const Text('Reto 3: Clima'),
              subtitle: const Text('Clima actual de tu ciudad'),
              onTap: () => abrir(context, const PantallaClima()),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Text('🪙', style: TextStyle(fontSize: 30)),
              title: const Text('Reto 4: Criptomonedas'),
              subtitle: const Text('Convierte dólares a BTC, ETH y SOL'),
              onTap: () => abrir(context, const PantallaCripto()),
            ),
          ),
        ],
      ),
    );
  }
}
