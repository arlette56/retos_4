import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../dominio/modelos.dart';
import '../../datos/config_claves.dart';

// Una clase por API. (El Reto 2 de gatos no necesita servicio:
// solo arma una URL y la muestra con Image.network.)

// Cada estado de ánimo se relaciona con un género de TMDB (su número de id).
const Map<String, int> estadosDeAnimo = {
  '😄 Feliz': 35, // Comedia
  '🤩 Con energía': 28, // Acción
  '😢 Triste': 18, // Drama
  '😱 Quiero miedo': 27, // Terror
  '🥰 Romántico': 10749, // Romance
  '🧸 Relajado': 16, // Animación
};

// ---------- Reto 1: TMDB ----------
class ServicioPeliculas {
  static const String base = 'https://api.themoviedb.org/3';

  // Películas en tendencia de la semana.
  static Future<List<Pelicula>> tendencias() async {
    final url = Uri.parse(
        '$base/trending/movie/week?api_key=$tmdbApiKey&language=es-MX');
    return _pedir(url);
  }

  // Películas populares de un género.
  static Future<List<Pelicula>> porGenero(int genero) async {
    final url = Uri.parse('$base/discover/movie?api_key=$tmdbApiKey'
        '&language=es-MX&sort_by=popularity.desc&with_genres=$genero');
    return _pedir(url);
  }

  static Future<List<Pelicula>> _pedir(Uri url) async {
    final respuesta = await http.get(url);
    if (respuesta.statusCode != 200) {
      throw Exception('Error ${respuesta.statusCode}. ¿Pusiste tu API key?');
    }
    final datos = jsonDecode(respuesta.body);
    final List resultados = datos['results'];
    return resultados.map((p) => Pelicula.fromJson(p)).toList();
  }
}

// ---------- Reto 3: OpenWeatherMap ----------
class ServicioClima {
  static Future<Clima> obtenerClima(String ciudad) async {
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather'
        '?q=${Uri.encodeComponent(ciudad)}&appid=$climaApiKey&units=metric&lang=es');
    final respuesta = await http.get(url);

    if (respuesta.statusCode == 401) {
      throw Exception('API key inválida o aún no activada.');
    }
    if (respuesta.statusCode == 404) {
      throw Exception('No encontré la ciudad "$ciudad".');
    }
    if (respuesta.statusCode != 200) {
      throw Exception('Error ${respuesta.statusCode}');
    }
    return Clima.fromJson(jsonDecode(respuesta.body));
  }
}

// ---------- Reto 4: CoinGecko (no necesita key) ----------
// Endpoint simple de precios:
// https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,solana&vs_currencies=usd
// Respuesta: {"bitcoin":{"usd":95000.0},"ethereum":{"usd":3500.0},"solana":{"usd":200.0}}
class ServicioCripto {
  static Future<List<Cripto>> obtenerPrecios() async {
    final url = Uri.parse('https://api.coingecko.com/api/v3/simple/price'
        '?ids=bitcoin,ethereum,solana&vs_currencies=usd');
    final respuesta = await http.get(url);

    if (respuesta.statusCode == 429) {
      throw Exception('Demasiadas consultas. Espera un minuto y recarga.');
    }
    if (respuesta.statusCode != 200) {
      throw Exception('Error ${respuesta.statusCode}');
    }

    final datos = jsonDecode(respuesta.body);
    return [
      Cripto('bitcoin', 'Bitcoin', 'BTC', (datos['bitcoin']['usd']).toDouble()),
      Cripto('ethereum', 'Ethereum', 'ETH', (datos['ethereum']['usd']).toDouble()),
      Cripto('solana', 'Solana', 'SOL', (datos['solana']['usd']).toDouble()),
    ];
  }
}
