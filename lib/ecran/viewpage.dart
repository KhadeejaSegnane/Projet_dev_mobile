import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recipe_app/modele/recette.dart';

// Définissez _Collection ici en tant que référence à votre collection Firestore
final CollectionReference _Collection =
    FirebaseFirestore.instance.collection('DocumentSnapshot');

class ViewPage extends StatelessWidget {
  final Recipe recipe;

  ViewPage({required this.recipe});

  void _saveToTxtFile() async {
    final String fileName = "recette.txt";
    final Directory? directory = await getExternalStorageDirectory();
    final File file = File('${directory?.path}/$fileName');
    final String content = """
Nom : ${recipe.name}
Ingrédients :
${recipe.ingredients.map((ingredient) => "- $ingredient").join('\n')}
Étapes :
${recipe.steps.map((step) => "- $step").join('\n')}
    """;

    await file.writeAsString(content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Détails de la recette"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nom : ${recipe.name}"),
            Text("Ingrédients :"),
            for (var ingredient in recipe.ingredients) Text("- $ingredient"),
            Text("Étapes :"),
            for (var step in recipe.steps) Text("- $step"),
            ElevatedButton(
              onPressed: _saveToTxtFile,
              child: Text("Enregistrer"),
            ),
          ],
        ),
      ),
    );
  }
}

// La méthode viewRecipe en dehors de la classe ViewPage
Future<Recipe?> viewRecipe({required String docId}) async {
  try {
    DocumentSnapshot documentSnapshot = await _Collection.doc(docId).get();
    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      String name = data['name'] as String;
      String ingredientsString = data['ingredients'] as String;
      String stepsString = data['steps'] as String;

      List<String> ingredients = ingredientsString.split(', ');
      List<String> steps = stepsString.split('\n');

      Recipe recipe = Recipe(
        id: docId,
        name: name,
        ingredients: ingredients,
        steps: steps,
      );

      return recipe;
    } else {
      // La recette n'existe pas
      return null;
    }
  } catch (e) {
    // Gérer les erreurs de récupération
    print(e.toString());
    return null;
  }
}
