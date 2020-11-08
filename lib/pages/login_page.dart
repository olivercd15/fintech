//import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parcial1_sw1/login_state.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(flex: 1, child: Container()),
            Text(
              "Proyecto de Software: FINTECH",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              // child: Image.asset('assets/img/login2.svg'),
            ),
            Expanded(flex: 1, child: Container()),
            Consumer<LoginState>(
              builder: (BuildContext context, LoginState state, Widget child) {
                return child;
              },
              child: IconButton(
                icon: Icon(FontAwesomeIcons.google),
                iconSize: 40.0,
                tooltip: "Iniciar Sesion con Google",
                onPressed: () {
                  Provider.of<LoginState>(context, listen: false).login();
                },
              ),
            ),
            Text(
              "Inicia Sesion con Google",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Expanded(flex: 1, child: Container()),
          ],
        ),
      ),
    );
  }
}
