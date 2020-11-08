import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginState with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _logged = false;
  bool isLogged() => _logged;
  FirebaseUser _user;
  FirebaseUser currentUser() => _user;

  void login() async {
    _user = await _handleSignIn();

    if (_user != null) {
      _logged = true;
      notifyListeners();
    } else {
      _logged = false;
      notifyListeners();
    }
  }

  void logout() {
    _googleSignIn.signOut();
    _logged = false;
    notifyListeners();
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser firebaseUser = authResult.user;
    String name = firebaseUser.displayName;
    print("Bienvenido: " + name);
    return firebaseUser;

  }
}
