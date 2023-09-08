import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pokedex/detail_screen.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List? pokedex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (mounted) {
      fetchPokemonData();
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    Color _greenColor = Color(0xff2a9d8f);
    Color _redColor = Color(0xffe76f51);
    Color _blueColor = Color(0xff37A5C6);

    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          Positioned(
            top: -50,
            right: -50,
            child: Image.asset(
              'images/pokeball.png',
              width: 200,
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
              top: 100,
              left: 20,
              child: Text(
                'Pokedex',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              )),
          Positioned(
            top: 150,
            bottom: 0,
            width: width,
            child: Column(
              children: [
                pokedex != null
                    ? Expanded(
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, childAspectRatio: 1.4),
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: pokedex?.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                child: InkWell(
                                  child: SafeArea(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: returnColorClass(
                                              pokedex?[index]['type'][0]),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(25))),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            bottom: -10,
                                            right: -10,
                                            child: Image.asset(
                                              'images/pokeball.png',
                                              height: 100,
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 5,
                                            right: 5,
                                            child: Hero(
                                              tag: index,
                                              child: CachedNetworkImage(
                                                  imageUrl: pokedex?[index]
                                                      ['img'],
                                                  height: 100,
                                                  fit: BoxFit.fitHeight,
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      )),
                                            ),
                                          ),
                                          Positioned(
                                            top: 55,
                                            left: 15,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(20)),
                                                  color: Colors.black
                                                      .withOpacity(0.5)),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0,
                                                    right: 10,
                                                    top: 5,
                                                    bottom: 5),
                                                child: Text(
                                                  pokedex?[index]['type'][0],
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      shadows: [
                                                        BoxShadow(
                                                            color:
                                                                Colors.blueGrey,
                                                            offset:
                                                                Offset(0, 0),
                                                            spreadRadius: 1.0,
                                                            blurRadius: 15)
                                                      ]),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 30,
                                            left: 15,
                                            child: Text(
                                              pokedex?[index]['name'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  shadows: [
                                                    BoxShadow(
                                                        color: Colors.blueGrey,
                                                        offset: Offset(0, 0),
                                                        spreadRadius: 1.0,
                                                        blurRadius: 15)
                                                  ]),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => DetailScreen(
                                                  heroTag: index,
                                                  pokemonDetail:
                                                      pokedex?[index],
                                                  color: returnColorClass(
                                                      pokedex?[index]['type']
                                                          [0]),
                                                )));
                                  },
                                ),
                              );
                            }))
                    : const Center(
                        child: CircularProgressIndicator(),
                      )
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: SizedBox(
              height: 150,
              width: width,
            ),
          ),
        ]));
  }

  void fetchPokemonData() {
    var url = Uri.https('raw.githubusercontent.com',
        '/Biuni/PokemonGO-Pokedex/master/pokedex.json');
    http.get(url).then((value) {
      if (value.statusCode == 200) {
        var data = jsonDecode(value.body);
        pokedex = data['pokemon'];
        setState(() {});
      }
    }).catchError((e) {
      print(e);
    });
  }

  returnColorClass(String type) {
    Map mappingColorType = {
      "Grass": Colors.greenAccent,
      "Fire": Colors.redAccent,
      "Water": Colors.blue,
      "Poison": Colors.deepPurpleAccent,
      "Electric": Colors.amber,
      "Rock": Colors.grey,
      "Ground": Colors.brown,
      "Psychic": Colors.indigo,
      "Fighting": Colors.orange,
      "Bug": Colors.lightGreenAccent,
      "Ghost": Colors.deepPurple,
      "Normal": const Color(0xffe0e0e0),
    };
    if (mappingColorType[type] != null) {
      return mappingColorType[type];
    } else {
      return Colors.pink;
    }
  }
}
