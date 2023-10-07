import 'package:provider/provider.dart';
import 'package:recipe_app/ecran/Home.dart';
import 'package:recipe_app/ecran/handler.dart';
import 'package:recipe_app/ecran/listpage.dart';
import 'package:recipe_app/modele/firebaseuser.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget{
  
  @override
  Widget build(BuildContext context) {
    
    final user =  Provider.of<FirebaseUser?>(context);
    
     if(user == null)
     {
       return Handler();
     }else
     {
       return Home();
     }

  }
} 