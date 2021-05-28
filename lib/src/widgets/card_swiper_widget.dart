import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {

  final List<Pelicula> peliculas;

  const CardSwiper({Key key, @required this.peliculas}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //Toma el tamaño total de la pantalla
    final _screenSize = MediaQuery.of(context).size;
    
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      // width: double.infinity,
      child: Swiper(
        //acomoda los cards del swiper uno sobre otro
        layout: SwiperLayout.STACK,
        itemBuilder: (BuildContext context, int index){
          peliculas[index].uniqueId = '${peliculas[index].id}-tarjeta';
          //ClipRRect se usa para hacer widgets redondeados
          return Hero(
            tag: peliculas[index].uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'detalle', arguments: peliculas[index]),
                child: FadeInImage(
                  image: NetworkImage(peliculas[index].getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        itemCount: peliculas.length,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        // pagination: new SwiperPagination(),
        // control: new SwiperControl(),
      ),
    );
  }
}