import 'package:pokedex/models/pokemon_data.dart';
import 'package:pokedex/utils/constants.dart';

class Pokemon {
  String pokemonName;
  String pokemonUrl;
  PokemonData? pokemonData;

  Pokemon({required this.pokemonName, required this.pokemonUrl});

  get pokemonId {
    var urlParts = pokemonUrl.split('/');
    var id = urlParts.reversed.skip(1).first;
    return int.parse(id);
  }

  get pokemonImage => '$pokemonImgUrl/$pokemonId.png';

  factory Pokemon.fromJson(Map<String, dynamic> jsonData) {
    return Pokemon(pokemonName: jsonData['name'], pokemonUrl: jsonData['url']);
  }
}
