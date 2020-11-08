//import 'dart:html';

//import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
//import 'package:parcial1_sw1/detail_screen.dart';
import 'package:parcial1_sw1/login_state.dart';
import 'package:parcial1_sw1/pages/add_page.dart';
//import 'package:flutter/rendering.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:parcial1_sw1/graph_widget.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:parcial1_sw1/mes_widget.dart';
import 'package:parcial1_sw1/pages/home_page.dart';
import 'package:parcial1_sw1/pages/list_page.dart';
import 'package:parcial1_sw1/pages/login_page.dart';
import 'package:parcial1_sw1/pages/text_page.dart';
import 'package:parcial1_sw1/pages/voice_page.dart';
import 'package:provider/provider.dart';
//import 'package:camera/camera.dart';
//import 'package:firebase_core/firebase_core.dart';
//List<CameraDescription> cameras = [];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider <LoginState>(
      create: (context) => LoginState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // ignore: missing_return
        onGenerateRoute: (settings) {
          if (settings.name == '/list') {
            int mesActual = settings.arguments;
            return MaterialPageRoute(
              builder: (BuildContext context) {
                return ListPage(mesActual: mesActual);
              }
            ); 
          }
        },
        routes: {
          '/': (BuildContext context) {
            var state = Provider.of<LoginState>(context);
            if (state.isLogged()) {
              return MyHomePage();
            } else {
              return LoginPage();
            }
          },
          '/add': (BuildContext context) => AddPage(),
          '/voice': (BuildContext context) => VoicePage(),
          '/text': (BuildContext context) => TextPage(),
         // '/list': (BuildContext context) => ListPage(),
        },
      ),
    );
  }
}
