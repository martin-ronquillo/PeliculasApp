import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/models/actores_model.dart';

class PeliculasProvider {
  
  String _apikey      = '164738d3dbda7633273233825144c116';
  String _url         = 'api.themoviedb.org';
  String _language    = 'es-ES';
  int _popularesPage  = 0;
  bool _cargando = false;

  List<Pelicula> _populares = [];

  //Es necesario cerrar el stream con el metodo Dispose
  //El broadcast Ayuda a que muchos widgets sean capaces de escuchar el stream a la vez
  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  //sink, ayuda a introducir elementos en el afluente del stream 
  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;
  //stream, permite obtener los datos que se hayan añadido al afluente del stream
  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams(){
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get( url );
    final decodedData = json.decode(resp.body);

    final peliculasPopulares = new Peliculas.fromJsonList(decodedData['results']);

    return peliculasPopulares.items;
  }

  Future<List<Pelicula>> getEnCines() async {

    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key' : _apikey,
      'language': _language,
    });

    return await _procesarRespuesta(url);

  }

  Future<List<Pelicula>> getPopulares() async {

    if(_cargando) return [];

    _cargando = true;

    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key' : _apikey,
      'language': _language,
      'page'    : _popularesPage.toString(),
    });
    
    final resp = await _procesarRespuesta(url);
    //Se usa AddAll porque asi se pueden insertar 
    //todos los registros de una lista a la vez
    _populares.addAll(resp);

    popularesSink(_populares);

    _cargando = false;

    return resp;

  }

  Future<List<Actor>> getCast(String peliId) async {

    final url = Uri.https(_url, '3/movie/$peliId/credits', {
      'api_key' : _apikey,
      'language': _language,
    });

    final resp = await http.get(url);
    //regresa un mapa formato json de la respuesta
    final decodedData = json.decode( resp.body );
    
    final cast = new Cast.fromJsonList(decodedData['cast']);
    
    return cast.actores;

  }

  Future<List<Pelicula>> buscarPelicula(String query) async {

    final url = Uri.https(_url, '3/search/movie', {
      'api_key' : _apikey,
      'language': _language,
      'query'   : query
    });

    return await _procesarRespuesta(url);

  }
}