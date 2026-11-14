// Modelos: clases con los datos que vienen de las APIs.

// Modelo: datos de una película (Reto 1 - TMDB).
class Pelicula {
  final String titulo;
  final String descripcion;
  final String? poster;
  final double calificacion;

  Pelicula({
    required this.titulo,
    required this.descripcion,
    required this.poster,
    required this.calificacion,
  });

  // Convierte el JSON de TMDB en un objeto Pelicula.
  factory Pelicula.fromJson(Map<String, dynamic> json) {
    return Pelicula(
      titulo: json['title'] ?? 'Sin título',
      descripcion: json['overview'] ?? '',
      poster: json['poster_path'],
      calificacion: (json['vote_average'] ?? 0).toDouble(),
    );
  }
}

// Modelo: datos del clima que nos interesan (Reto 3 - OpenWeatherMap).
class Clima {
  final String ciudad;
  final double temperatura;
  final double sensacion;
  final int humedad;
  final double viento;
  final String descripcion;
  final String icono;

  Clima({
    required this.ciudad,
    required this.temperatura,
    required this.sensacion,
    required this.humedad,
    required this.viento,
    required this.descripcion,
    required this.icono,
  });

  // Parseo del JSON anidado de OpenWeatherMap.
  factory Clima.fromJson(Map<String, dynamic> json) {
    return Clima(
      ciudad: json['name'],
      temperatura: (json['main']['temp']).toDouble(),
      sensacion: (json['main']['feels_like']).toDouble(),
      humedad: json['main']['humidity'],
      viento: (json['wind']['speed']).toDouble(),
      descripcion: json['weather'][0]['description'],
      icono: json['weather'][0]['icon'],
    );
  }
}

// Modelo: una criptomoneda con su precio en dólares (Reto 4 - CoinGecko).
class Cripto {
  final String id; // nombre que usa la API
  final String nombre;
  final String simbolo;
  final double precio;

  Cripto(this.id, this.nombre, this.simbolo, this.precio);
}
