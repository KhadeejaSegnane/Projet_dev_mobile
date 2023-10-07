import 'package:flutter/material.dart';
import 'package:recipe_app/ecran/listpage.dart';
import 'package:recipe_app/modele/recette.dart';
import 'package:recipe_app/services/RecipeService.dart';

class EditPage extends StatefulWidget {
  final Recipe? recipe;

  EditPage({this.recipe});

  @override
  State<StatefulWidget> createState() {
    return _EditPageState();
  }
}

class _EditPageState extends State<EditPage> {
  final _recipe_name = TextEditingController();
  final List<String> _recipe_ingredients = [];
  final List<String> _recipe_steps = [];
  final _docid = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialisez les contrôleurs avec les valeurs de la recette
    if (widget.recipe != null) {
      _docid.text = widget.recipe!.id ?? "";
      _recipe_name.text = widget.recipe!.name ?? "";
      _recipe_ingredients.addAll(widget.recipe!.ingredients ?? []);
      _recipe_steps.addAll(widget.recipe!.steps ?? []);
    }
  }

  // Fonction pour générer les champs de texte pour les ingrédients
  List<Widget> buildIngredientTextFields() {
    List<Widget> ingredientTextFields = [];

    for (int i = 0; i < _recipe_ingredients.length; i++) {
      ingredientTextFields.add(
        TextFormField(
          controller: TextEditingController(text: _recipe_ingredients[i]),
          onChanged: (value) {
            setState(() {
              _recipe_ingredients[i] = value;
            });
          },
          decoration: InputDecoration(
            hintText: "Ingrédient ${i + 1}",
          ),
        ),
      );
    }

    return ingredientTextFields;
  }

  // Fonction pour générer les champs de texte pour les étapes
  List<Widget> buildStepTextFields() {
    List<Widget> stepTextFields = [];

    for (int i = 0; i < _recipe_steps.length; i++) {
      stepTextFields.add(
        TextFormField(
          controller: TextEditingController(text: _recipe_steps[i]),
          onChanged: (value) {
            setState(() {
              _recipe_steps[i] = value;
            });
          },
          decoration: InputDecoration(
            hintText: "Étape ${i + 1}",
          ),
        ),
      );
    }

    return stepTextFields;
  }
// Etape de création d'une recette avec les ingrédients, les étapes et l'enregistrement 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Éditer la recette"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _recipe_name,
                decoration: InputDecoration(
                  labelText: "Nom de la recette",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer un nom pour la recette";
                  }
                  return null;
                },
              ),
              Text("Ingrédients:"),
              ...buildIngredientTextFields(),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _recipe_ingredients.add("");
                  });
                },
                child: Text("Ajouter Ingrédient"),
              ),
              Text("Étapes:"),
              ...buildStepTextFields(),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _recipe_steps.add("");
                  });
                },
                child: Text("Ajouter Étape"),
              ),


//Sauvegarde de la recette
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    RecipeService.editRecipe(id: widget.recipe!.id, name: _recipe_name.value.text, ingredients: _recipe_ingredients, steps: _recipe_steps);
                  }
                },
                child: Text("Enregistrer"),
              ),


              //Pour retourner à l'accueil après modification d'une recette
              ElevatedButton(
                onPressed: () {
                  list_navigate();
                },
                child: Text("Accueil"),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void list_navigate() {
    Navigator.pushAndRemoveUntil<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) => ListPage(),
                              ),
                              (route) =>
                                  false,
                            );
  }
}
