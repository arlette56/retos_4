import 'dart:math';

import 'package:flutter/material.dart';

import '../datos/servicios.dart';
import '../dominio/modelos.dart';

// Reto 1: Películas según tu estado de ánimo.
class PantallaPeliculas extends StatefulWidget {
  const PantallaPeliculas({super.key});

  @override
  State<PantallaPeliculas> createState() => _PantallaPeliculasState();
}

class _PantallaPeliculasState extends State<PantallaPeliculas> {
  List<Pelicula> peliculas = [];
  Pelicula? alAzar;
  bool cargando = false;
  String? error;
  String titulo = 'Tendencias de la semana';

  @override
  void initState() {
    super.initState();
    cargarTendencias();
  }

  Future<void> cargarTendencias() async {
    setState(() {
      cargando = true;
      error = null;
      alAzar = null;
      titulo = 'Tendencias de la semana';
    });
    try {
      peliculas = await ServicioPeliculas.tendencias();
    } catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() => cargando = false);
  }

  // Trae películas del género y elige una al azar.
  Future<void> recomendar(String animo, int genero) async {
    setState(() {
      cargando = true;
      error = null;
      titulo = 'Para cuando te sientes $animo';
    });
    try {
      peliculas = await ServicioPeliculas.porGenero(genero);
      if (peliculas.isNotEmpty) {
        alAzar = peliculas[Random().nextInt(peliculas.length)];
      }
    } catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() => cargando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas del fin de semana'),
        actions: [
          IconButton(
            icon: const Icon(Icons.trending_up),
            tooltip: 'Ver tendencias',
            onPressed: cargarTendencias,
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text('¿Cómo te sientes hoy?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          // Botones de estado de ánimo
          Wrap(
            spacing: 8,
            children: estadosDeAnimo.entries.map((e) {
              return ActionChip(
                label: Text(e.key),
                onPressed: () => recomendar(e.key, e.value),
              );
            }).toList(),
          ),
          const Divider(),
          Expanded(child: contenido()),
        ],
      ),
    );
  }

  Widget contenido() {
    if (cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(error!, textAlign: TextAlign.center),
        ),
      );
    }
    return ListView(
      children: [
        if (alAzar != null) ...[
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text('🎲 Te recomiendo:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          TarjetaPelicula(pelicula: alAzar!, destacada: true),
          const Divider(),
        ],
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(titulo,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        ...peliculas.map((p) => TarjetaPelicula(pelicula: p)),
      ],
    );
  }
}

// Tarjeta (Card) con póster, título, calificación y descripción.
class TarjetaPelicula extends StatelessWidget {
  final Pelicula pelicula;
  final bool destacada;

  const TarjetaPelicula(
      {super.key, required this.pelicula, this.destacada = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: destacada ? Colors.amber.shade100 : null,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: pelicula.poster != null
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w200${pelicula.poster}',
                      width: 90,
                    )
                  : Container(
                      width: 90,
                      height: 135,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.movie),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pelicula.titulo,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('⭐ ${pelicula.calificacion.toStringAsFixed(1)}'),
                  const SizedBox(height: 4),
                  Text(
                    pelicula.descripcion.isEmpty
                        ? 'Sin descripción.'
                        : pelicula.descripcion,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
