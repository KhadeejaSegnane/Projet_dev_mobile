import 'package:flutter/material.dart';
import 'package:recipe_app/ecran/Register.dart';
import 'package:recipe_app/ecran/login.dart';
// Classe Handler, un StatefulWidget qui gère l'affichage de l'écran de connexion 
// ou d'inscription.

class Handler extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Handler();
  }
}

class _Handler extends State<Handler> {

  bool showSignin = true;

  void toggleView(){
    setState(() {
      showSignin = !showSignin;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showSignin)
    {
       return Login(toggleView : toggleView);
    }else
    {
      return Register(toggleView : toggleView);
    }
  }
}