// Modèle de données
class Recipe {
  final String id;
  final String name;
  final List<String> ingredients;
  final List<String> steps;

  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.steps,
  });
}

