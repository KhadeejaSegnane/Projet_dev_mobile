import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_app/modele/firebaseuser.dart';
import 'package:recipe_app/modele/loginuser.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/services/AuthService.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future signInAnonymous() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User? user = userCredential.user;
      return _firebaseUser(user);
    } catch (e) {
     return FirebaseUser(code: e.toString(), uid: null);
    }
  }
  Future signInEmailPassword(LoginUser _login) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _login.email.toString(),
              password: _login.password.toString());
      User? user = userCredential.user;
      return _firebaseUser(user);
    } on FirebaseAuthException catch (e) {
      return FirebaseUser(code: e.code, uid: null);
    }
  }
  Future registerEmailPassword(LoginUser _login) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _login.email.toString(),
              password: _login.password.toString());
      User? user = userCredential.user;
      return _firebaseUser(user);
    } on FirebaseAuthException catch (e) {
      return FirebaseUser(code: e.code, uid: null);
    } catch (e) {
      return FirebaseUser(code: e.toString(), uid: null);
    }
  }
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
  FirebaseUser? _firebaseUser(User? user) {
    return user != null ? FirebaseUser(uid: user.uid) : null;
  }
  Stream<FirebaseUser?> get user {
    return _auth.authStateChanges().map(_firebaseUser);
  }
}

void main() {
  group('AuthService', () {
    final authService = AuthService();

    // Pour s'authentifier en anonyme
    test('Test d\'authentification anonyme réussi', () async {
      final user = await authService.signInAnonymous();
      expect(user, isNotNull);
    });

    // Pour se connecter
    test('Test de connexion par e-mail et mot de passe', () async {
      final loginUser = LoginUser(email: 'test@example.com', password: 'password');
      final user = await authService.signInEmailPassword(loginUser);
      expect(user, isNotNull);
    });

    // Pour s'inscrire
    test('Test d\'inscription par e-mail et mot de passe', () async {
      final loginUser = LoginUser(email: 'newuser@example.com', password: 'newpassword');
      final user = await authService.registerEmailPassword(loginUser);
      expect(user, isNotNull);
    });
    
    // Pour se déconnecter
    test('Test de déconnexion', () async {
      final result = await authService.signOut();
      expect(result, isNull);
    });
  });
}
