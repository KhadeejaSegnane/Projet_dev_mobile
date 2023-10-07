import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/ecran/addpage.dart';
import 'package:recipe_app/ecran/editpage.dart';
import 'package:recipe_app/modele/recette.dart';
import 'package:recipe_app/services/RecipeService.dart';

class ListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListPage();
  }
}

class _ListPage extends State<ListPage> {
  final Stream<QuerySnapshot> collectionReference = RecipeService.readRecipe();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
        stream: collectionReference,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: snapshot.data!.docs.map((e) {
                  List<String> liste_ingredients;
                  List<String> listes_steps ;
                  List<String> ingre2=e["ingredients"].toString().split(", ");
                  List<String> steps2=e["steps"].toString().split(", ");


                  final List<dynamic> ingredients =
                      e["ingredients"];
                      liste_ingredients = ingredients.map((e) => e.toString()).toList();
                      print(liste_ingredients);
                  final List<dynamic> steps =
                      e["steps"];
                      listes_steps=steps.map((e) => e.toString()).toList();
                      print("${listes_steps}etapes");
                      print(e["steps"]);

                  return Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(e['name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Ingrédients:"),
                              //Text(liste_ingredients),
                              for (var ingredient in ingre2) Text("- $ingredient"),
                              Text("Étapes:"),
                              //Text(listes_steps),
                              for (var step in steps2) Text("- $step"),
                            ],
                          ),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(5.0),
                                primary: const Color.fromARGB(255, 143, 133, 226),
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              child: const Text('Edit'), //Bouton pour modifier une recette
                          onPressed: () {
                            Navigator.pushAndRemoveUntil<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) => EditPage(
                                  recipe: Recipe(
                                      id: e.id,
                                      name: e["name"],
                                      ingredients: liste_ingredients,
                                      steps: listes_steps),
                                ),
                              ),
                              (route) =>
                                  false,
                            );
                          },
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(5.0),
                            primary: const Color.fromARGB(255, 143, 133, 226),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          child: const Text('Delete'), //Bouton pour supprimer une recette
                          onPressed: () async {
                            var response =
                                await RecipeService.deleteRecipe(docId: e.id);
                            if (response.code != 200) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content:
                                          Text(response.message.toString()),
                                    );
                                  });
                            }
                          },
                        ),
                      ],
                    ),
                  ]));
                }).toList(),
              ),
            );
          }


          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => AddPage(),
            ),
            (route) => false,
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
