import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';

class PokemonGrid extends StatefulWidget {
  const PokemonGrid({Key? key, required this.pokemonList}) : super(key: key);

  final List<Pokemon> pokemonList;

  @override
  _PokemonGridState createState() => _PokemonGridState();
}

class _PokemonGridState extends State<PokemonGrid> {
  late Pokemon _selectedPokemon;
  List<Pokemon> _randomPokemons = [];

  int _correctAnswers = 0;
  int _wrongAnswers = 0;
  int _totalAnswers = 0;
  bool _inResultsState = false;

  @override
  void initState() {
    super.initState();
    _getRandomPokemon();
  }

  void _getRandomPokemon() {
    final selectedIndex = <int>{};
    while (selectedIndex.length < 4) {
      selectedIndex.add(Random().nextInt(widget.pokemonList.length));
    }

    final selectedPokeIndex = selectedIndex.first;
    _selectedPokemon = widget.pokemonList[selectedPokeIndex];
    _randomPokemons = selectedIndex.map((index) {
      return widget.pokemonList[index];
    }).toList();
    _randomPokemons.shuffle();

    setState(() {});
  }

  void onButtonPressed(Pokemon pokemon) {
    if (_totalAnswers < 10 && !_inResultsState) {
      _totalAnswers++;

      if (pokemon == _selectedPokemon) {
        _correctAnswers++;
        _showResults(true);
      } else {
        _wrongAnswers++;
        _showResults(false);
      }

      if (_totalAnswers == 10) {
        if (_correctAnswers >= 6) {
          _showResultDialog(1);
        } else {
          _showResultDialog(2);
        }
      } else {
        _getRandomPokemon();
      }
    }
  }

  void _showResultDialog(int finalCorrectAnswers) {
    setState(() {
      _inResultsState = true;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Resultado final do quiz'),
          content: Text(finalCorrectAnswers == 1
              ? 'Você acertou $_correctAnswers, errou $_wrongAnswers e ficou acima da média, parabéns!'
              : 'Você acertou apenas $_correctAnswers, errou $_wrongAnswers e ficou abaixo da média, tente novamente!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _reloadQuiz();
                Navigator.of(context).pop();
              },
              child: const Text('Recarregar o quiz'),
            ),
          ],
        );
      },
    );
  }

  void _showResults(bool correctAnswer) {
    if (!_inResultsState) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(correctAnswer
                ? 'Você acertou a resposta :)'
                : 'Você errou a resposta :('),
            content: Text(correctAnswer
                ? 'Você acertou $_correctAnswers pokemon(s) até agora'
                : 'Você errou $_wrongAnswers pokemon(s) até agora'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Fechar'),
              ),
            ],
          );
        },
      );
    }
  }

  void _reloadQuiz() {
    setState(() {
      _inResultsState = false;
      _correctAnswers = 0;
      _wrongAnswers = 0;
      _totalAnswers = 0;
      _getRandomPokemon();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Acertou: $_correctAnswers",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(width: 80),
                  Text(
                    "Errou: $_wrongAnswers",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 2.1,
          child: Image.network(_selectedPokemon.pokemonImage),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            children: _randomPokemons.map((pokemon) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: SizedBox(
                  width: 350,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      onButtonPressed(pokemon);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    child: Text(
                      pokemon.pokemonName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
