import 'package:flutter/material.dart';
import 'package:whos_that_pokemon/guessing_template.dart';

void main() {
  runApp(const MaterialApp(
      title: 'Who\'s That Pokémon?',
      home: GameScreen()
  ));
}

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: const Text(
          'Who\'s That Pokémon?',
          style: TextStyle(
            fontFamily: 'ShinGoPro',
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: const SingleChildScrollView(
        child: GuessingGame(),
      ),
    );
  }
}
