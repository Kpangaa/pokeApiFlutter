import 'package:flutter/material.dart';
import 'package:flutter_pokedex/home_screen.dart';

void main() {
  runApp(Pokemon());
}

// ignore: use_key_in_widget_constructors
class Pokemon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
