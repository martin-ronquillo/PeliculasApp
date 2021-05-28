import 'package:flutter/material.dart';

import 'package:peliculas/src/models/pelicula_model.dart';

import 'package:peliculas/src/providers/peliculas_providers.dart';

class DataSearch extends SearchDelegate{

  String seleccion = '';

  final peliculasProvider = new PeliculasProvider();

  final peliculas = [
    'Gambito de dama',
    'Aquaman',
    'Batman',
    'Shazam!',
    'Iroman',
    'No Body',
  ];

  final peliculasRecientes = [
    'Spiderman',
    'Capitan America'
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar, ej: El icono de limpiar o cancelar busqueda
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Generalmente un icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ), 
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Sugerencias que aparecen al escribir en la busqueda

    if(query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        
        if(snapshot.hasData) {

          final peliculas = snapshot.data;

          return ListView(
            children: peliculas.map((pelicula) {
              return ListTile(
                leading: Hero(
                  tag: pelicula.uniqueId = '${pelicula.id}-poster',
                  child: FadeInImage(
                    image: NetworkImage(pelicula.getPosterImg()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    width: 50.0,
                    fit: BoxFit.contain,
                  ),
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: () => Navigator.pushNamed(context, 'detalle', arguments: pelicula),
                // onTap: () {
                //   el close cierra la busqueda. Se le envia null porque no regresa resultados
                //   close(context, null);
                //   Navigator.pushNamed(context, 'detalle', arguments: pelicula)
                // }
              );
            }).toList(),
          );

        } else  {

          return Center(
            child: CircularProgressIndicator(),
          );

        }

      },
    );

    // Ejemplo de explicacion de la clase


    //   final listaSugerida = (query.isEmpty) 
    //                       ? peliculasRecientes 
    //                       : peliculas.where(
    //                           (p) => p.toLowerCase().startsWith(query.toLowerCase())
    //                         ).toList();

    //   return ListView.builder(
    //     itemBuilder: (context, i) {
    //       return ListTile(
    //         leading: Icon(Icons.movie),
    //         title: Text(listaSugerida[i]),
    //         onTap: (){
    //           seleccion = listaSugerida[i];
    //           showResults(context);
    //         },
    //       );
    //     },
    //     itemCount: listaSugerida.length,
    //   );
  }

}