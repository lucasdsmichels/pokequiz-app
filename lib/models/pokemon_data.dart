class PokemonData {
  final int pokemonId;
  final int pokemonHeight;
  final int pokemonWeight;

  PokemonData({
    required this.pokemonId,
    required this.pokemonHeight,
    required this.pokemonWeight,
  });

  get heightInMeters => pokemonHeight / 10;
  get weightInKg => pokemonWeight / 10;

  factory PokemonData.fromJson(Map<String, dynamic> json) {
    return PokemonData(
      pokemonId: json['id'],
      pokemonHeight: json['height'],
      pokemonWeight: json['weight'],
    );
  }
}
