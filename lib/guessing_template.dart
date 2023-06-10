import 'package:flutter/material.dart';
import 'package:whos_that_pokemon/pokemon.dart';
import 'package:whos_that_pokemon/all_caps_input_formatter.dart';

class GuessingGame extends StatefulWidget {
  const GuessingGame({Key? key}) : super(key: key);

  @override
  State<GuessingGame> createState() => _GuessingGameState();
}

class _GuessingGameState extends State<GuessingGame> {
  late Future<Pokemon> randomPokemon;
  bool _isShowingPokemon = false;
  final TextEditingController _textEditingController = TextEditingController();
  final String _loadingPokeBallUrl = 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Pok%C3%A9_Ball_icon.svg/1200px-Pok%C3%A9_Ball_icon.svg.png';

  @override
  void initState() {
    super.initState();
    randomPokemon = getRandomPokemon();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void generateNewRandomPokemon() {
    _textEditingController.clear();
    randomPokemon = getRandomPokemon();
    setState(() {});
  }

  void revealPokemon() async {
    setState(() {
      _isShowingPokemon = true;
    });
    await Future.delayed(const Duration(seconds: 3));
    generateNewRandomPokemon();
    _isShowingPokemon = false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Pokemon>(
      future: randomPokemon,
      builder: (context, snapshot) {
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(
                  color: Colors.red[300]!,
                  width: 4.0
                ),
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                boxShadow: kElevationToShadow[12.0]
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(20.0),
              child: snapshot.connectionState == ConnectionState.done
                ? _isShowingPokemon
                  ? Image(image: NetworkImage(snapshot.data!.imageUrl))
                  : ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                        Colors.black,
                        BlendMode.modulate
                    ),
                    child: Image(image: NetworkImage(snapshot.data!.imageUrl))
                  )
                : Image(image: NetworkImage(_loadingPokeBallUrl))
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 20.0),
              child: TextField(
                inputFormatters: [
                  UpperCaseTextFormatter()
                ],
                controller: _textEditingController,
                keyboardType: TextInputType.visiblePassword,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                autocorrect: false,
                enableSuggestions: false,
                enabled: snapshot.connectionState == ConnectionState.done
                         && !_isShowingPokemon,
                showCursor: false,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 3.0
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(16.0))
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 3.0
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(16.0))
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 3.0
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(16.0))
                  ),
                  hintText: 'This Pokémon is...',
                  hintStyle: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey
                  ),
                  filled: true,
                  fillColor: Colors.grey[100]
                ),
                style: const TextStyle(
                  fontFamily: 'ShinGoPro',
                  letterSpacing: 2.0,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold
                ),
                onChanged: (value) {
                  if (snapshot.data!.name.toLowerCase() ==
                      value.toLowerCase()) {
                    FocusScope.of(context).unfocus();
                    _textEditingController.text =
                        snapshot.data!.name.toUpperCase();
                    revealPokemon();
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: snapshot.connectionState == ConnectionState.done
                         && !_isShowingPokemon
                ? () {
                _textEditingController.text = snapshot.data!.name.toUpperCase();
                revealPokemon();
                }
                : null,
              style: ButtonStyle(
                elevation: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.pressed) ||
                      states.contains(MaterialState.disabled)) {
                    return 0.00;
                  }
                  return 12.0;
                }),
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.grey;
                  }
                  return Colors.red[800];
                }),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                textStyle: MaterialStateProperty.all(const TextStyle(
                  fontFamily: 'ShinGoPro',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700
                ))
              ),
              child: const Text('I don\'t know.'),
            )
          ],
        );
      },
    );
  }
}