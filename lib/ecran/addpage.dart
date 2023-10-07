import 'package:flutter/material.dart';
import 'package:recipe_app/ecran/listpage.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/modele/responses.dart';

import '../services/RecipeService.dart';

class AddPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddPage();
  }
}

class _AddPage extends State<AddPage> {
  final _recipe_name = TextEditingController();
  final List<String> _recipe_ingredients = [];
  final List<String> _recipe_steps = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
      controller: _recipe_name,
      autofocus: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Name",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
// Ajouter les ingrédients de la recette
    final ingredientsField = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Ingrédients"),
        ListView.builder(
          itemCount: _recipe_ingredients.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: TextEditingController(text: _recipe_ingredients[index]),
                    onChanged: (value) {
                      _recipe_ingredients[index] = value;
                    },
                    decoration: InputDecoration(
                      hintText: "Ingrédient ${index + 1}",
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      _recipe_ingredients.removeAt(index);
                    });
                  },
                ),
              ],
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            setState(() {
              _recipe_ingredients.add("");
            });
          },
        ),
      ],
    );
// Ajouter les étapes de la recette
    final stepsField = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Étapes à suivre"),
        ListView.builder(
          itemCount: _recipe_steps.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: TextEditingController(text: _recipe_steps[index]),
                    onChanged: (value) {
                      _recipe_steps[index] = value;
                    },
                    decoration: InputDecoration(
                      hintText: "Étape ${index + 1}",
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      _recipe_steps.removeAt(index);
                    });
                  },
                ),
              ],
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            setState(() {
              _recipe_steps.add("");
            });
          },
        ),
      ],
    );

    final viewListbutton = TextButton(
      onPressed: () {
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => ListPage(),
          ),
          (route) => false, 
        );
      },
      child: const Text('Retour à la liste des recettes'),
    );
// Bouton de savegarde
    final SaveButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            var response = await RecipeService.addRecipe(
              name: _recipe_name.text,
              ingredients: _recipe_ingredients,
              steps: _recipe_steps,
            );
            print(response);
          }
        },
        child: Text(
          "Save",
          style: TextStyle(color: Theme.of(context).primaryColorLight),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Ajouter une recette'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  nameField,
                  const SizedBox(height: 25.0),
                  ingredientsField,
                  const SizedBox(height: 35.0),
                  stepsField,
                  viewListbutton,
                  const SizedBox(height: 45.0),
                  SaveButton,
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
