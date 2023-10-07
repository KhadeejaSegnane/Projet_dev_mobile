import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/modele/recette.dart';
import 'package:recipe_app/modele/responses.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/services/RecipeService.dart';

class RecipeService {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static CollectionReference _Collection = _firestore.collection("Recipe");
 // Pour lister une recette
  static Stream<QuerySnapshot> readRecipe() {
    CollectionReference notesItemCollection = _Collection;
    return notesItemCollection.snapshots();
  }
// Pour modifier une recette
static Future<Response> updateRecipe({
  required String name,
  required List<String> ingredients,
  required List<String> steps,
  required String id,
}) async {
  Response response = Response();
  DocumentReference documentReferencer = _Collection.doc(id);

  Map<String, dynamic> data = <String, dynamic>{
    "name": name,
    "ingredients": ingredients.join(', '), // Conversion de la liste en une chaîne de caractères
    "steps": steps.join('\n'), // Conversion de la liste en une chaîne de caractères avec des sauts de ligne
  };

  await documentReferencer
      .update(data)
      .whenComplete(() {
        response.code = 200;
        response.message = "Recette mise à jour avec succès";
      })
      .catchError((e) {
        response.code = 500;
        response.message = e.toString();
      });

  return response;
}
// Pour ajouter un recette sur la base de données
  static addRecipe({required String name, required List<String> ingredients, required List<String> steps}) {
    FirebaseFirestore.instance.collection("Recipe").add({"name": name,"ingredients": ingredients,"steps": steps});
  }
// Pour modifier un recette sur la base de données
  static editRecipe({required String id, required String name, required  List<String> ingredients, required List<String> steps}) {
    FirebaseFirestore.instance.collection("Recipe").doc(id).update({ "name": name,"ingredients": ingredients,"steps": steps});
  }
// Pour supprimer un recette sur la base de données
  static deleteRecipe({required String docId}) {
    FirebaseFirestore.instance.collection("Recipe").doc(docId).delete();

  }

}

// Sauvegarde de Recettes préférées
class FavoriteRecipesService {
  final CollectionReference _favoriteRecipesCollection =
      FirebaseFirestore.instance.collection('favorite_recipes');

  Future<void> addRecipeToFavorites(String userId, String recipeId) async {
    // Utilisez l'ID de l'utilisateur comme nom du document
    final userDoc = _favoriteRecipesCollection.doc(userId);

    try {
      // Obtenez la liste actuelle des recettes préférées de l'utilisateur
      final userSnapshot = await userDoc.get();
      final favoriteRecipes = userSnapshot.data() as List<String>? ?? [];

      // Vérifiez si la recette n'est pas déjà dans la liste
      if (!favoriteRecipes.contains(recipeId)) {
      // Ajoutez l'ID de la recette à la liste
        favoriteRecipes.add(recipeId);

      // Mettez à jour la liste des recettes préférées de l'utilisateur
        await userDoc.set({'favorite_recipes': favoriteRecipes});
      }
    } catch (e) {
      print('Erreur lors de l\'ajout de la recette aux recettes préférées : $e');
    }
  }
}


void main() {
  group('RecipeService', () {
    final recipeService = RecipeService();
    String? addedRecipeId; // Variable pour stocker l'ID de la recette ajoutée

    test('Test de lecture des recettes', () async {
      final recipes = await RecipeService.readRecipe().toList();
      expect(recipes, isNotEmpty);
    });

    test('Test d\'ajout de recette', () async {
      final addResult = await RecipeService.addRecipe(
        name: 'Nouvelle recette',
        ingredients: ['Ingrédient 1', 'Ingrédient 2'],
        steps: ['Étape 1', 'Étape 2'],
      );
      expect(addResult, isNotNull);
      addedRecipeId = addResult.id; // Stockez l'ID de la recette ajoutée
    });

    test('Test de modification de recette', () async {
      if (addedRecipeId != null) {
        final updatedResult = await RecipeService.updateRecipe(
          name: 'Recette modifiée',
          ingredients: ['Ingrédient A', 'Ingrédient B'],
          steps: ['Nouvelle étape 1', 'Nouvelle étape 2'],
          id: addedRecipeId!, 
        );

        expect(updatedResult, isNotNull);
      } else {
        fail('L\'ID de la recette ajoutée est null.');
      }
    });

    test('Test de suppression de recette', () async {
      if (addedRecipeId != null) {
        final result = await RecipeService.deleteRecipe(docId: addedRecipeId!);
        expect(result, isNotNull);
      } else {
        fail('L\'ID de la recette ajoutée est null.');
      }
    });
  });
}
