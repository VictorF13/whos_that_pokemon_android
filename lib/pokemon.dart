import 'dart:convert';
import 'package:http/http.dart';
import 'dart:math';

class Pokemon {
  int dexNumber;
  late String name;
  late String imageUrl;

  Pokemon({required this.dexNumber});

  Future<void> getProperties() async {
    Response response = await get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon/$dexNumber'));
    Map pokemonData = jsonDecode(response.body);
    name = pokemonData['name']!;
    imageUrl =
        pokemonData['sprites']['other']['official-artwork']['front_default']!;
  }
}

Future<Pokemon> getRandomPokemon() async {
  int randomDexNumber = 1 + Random().nextInt(151);
  Pokemon randomPokemon = Pokemon(dexNumber: randomDexNumber);
  await randomPokemon.getProperties();
  return randomPokemon;
}
