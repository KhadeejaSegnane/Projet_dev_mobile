import 'dart:ui_web';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/ecran/wrapper.dart';
import 'package:recipe_app/modele/firebaseuser.dart';
import 'package:recipe_app/services/authservice.dart';
import 'package:firebase_core_web/firebase_core_web.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initializeApp = Firebase.initializeApp(
    options: const FirebaseOptions(
      appId: '1:106193925547:android:020a4f8fc843adf9af0eee',
      apiKey: 'AIzaSyD9pEiHviPvE3VqpfD_S1OD9_8R0-mmgLw',
      projectId: 'projet-application-de-recette',
      messagingSenderId: '106193925547',
      authDomain: 'Projet-Application-Recette.firebaseapp.com',
      storageBucket: 'gs://[projet-application-de-recette].appspot.com',
    ),
  );
  await initializeApp;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
     Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child:Center(
        child: Image.network("https://images.pexels.com/photos/4551832/pexels-photo-4551832.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
        ),
      );
    return StreamProvider<FirebaseUser?>.value(
      value: AuthService().user,
       initialData: null,
       child: MaterialApp(
        debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color.fromARGB(255, 141, 145, 41),
        buttonTheme: ButtonThemeData(
          buttonColor: Color.fromARGB(255, 40, 8, 20),
          textTheme: ButtonTextTheme.primary,
          colorScheme:
              Theme.of(context).colorScheme.copyWith(secondary: Colors.white),
        ),
        fontFamily: 'Georgia',
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
        ),
      home: Wrapper(),
    ),);
  
  }
  
}


