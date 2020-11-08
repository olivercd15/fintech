import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parcial1_sw1/login_state.dart';
import 'package:parcial1_sw1/mes_widget.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController _controller;
  int currentPage = DateTime.now().month - 1;
  final firestoreInstance = Firestore.instance;

  Stream<QuerySnapshot> _query;

  @override
  void initState() {
    super.initState();

    // _query = Firestore.instance
    //  .collection('gasto')
    // .where("mes", isEqualTo: currentPage + 1)
    // .snapshots();

    _controller = PageController(
      initialPage: currentPage,
      viewportFraction: 0.4,
    );
  }

  Widget _bottomAction(IconData icon, Function callback) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon),
      ),
      onTap: callback,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginState>(
        builder: (BuildContext context, LoginState state, Widget child) {
      var user = Provider.of<LoginState>(context, listen: false).currentUser();
      _query = Firestore.instance
          .collection('usuario')
          .document(user.uid)
          .collection('gasto')
          .where("mes", isEqualTo: currentPage + 1)
          .snapshots();
      return Scaffold(
        bottomNavigationBar: BottomAppBar(
          notchMargin: 8.0,
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _bottomAction(FontAwesomeIcons.camera, () {
                Navigator.of(context).pushNamed('/text');
              }),
              _bottomAction(FontAwesomeIcons.microphone, () {
                Navigator.of(context).pushNamed('/voice');
              }),
              SizedBox(width: 48.0),
              _bottomAction(FontAwesomeIcons.wallet, () {
                Navigator.of(context).pushNamed('/list', arguments: currentPage);
              }),
              _bottomAction(FontAwesomeIcons.signOutAlt, () {
                Provider.of<LoginState>(context, listen: false).logout();
              }),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed('/add');
          },
        ),
        body: _body(),
      );
    });
  }

  Widget _body() {
    return SafeArea(
        child: Column(
      children: <Widget>[
        _selector(),
        StreamBuilder<QuerySnapshot>(
          stream: _query,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
            if (data.hasData) {
              return MesWidget(
                documents: data.data.documents,
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),

        //MesWidget(),
      ],
    ));
  }

  Widget _pageItem(String name, int position) {
    var _alignment;

    final selected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey,
    );
    final unselected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
      color: Colors.blueGrey.withOpacity(0.4),
    );

    if (position == currentPage) {
      _alignment = Alignment.center;
    } else if (position > currentPage) {
      _alignment = Alignment.centerRight;
    } else {
      _alignment = Alignment.centerLeft;
    }

    return Align(
      alignment: _alignment,
      child: Text(
        name,
        style: position == currentPage ? selected : unselected,
      ),
    );
  }

  Widget _selector() {
    return SizedBox.fromSize(
      size: Size.fromHeight(70.0),
      child: PageView(
        onPageChanged: (newPage) {
          setState(() {
            var user =
                Provider.of<LoginState>(context, listen: false).currentUser();
            currentPage = newPage;
            _query = Firestore.instance
                .collection('usuario')
                .document(user.uid)
                .collection('gasto')
                .where("mes", isEqualTo: currentPage + 1)
                .snapshots();
          });
        },
        controller: _controller,
        children: <Widget>[
          _pageItem("Enero", 0),
          _pageItem("Febrero", 1),
          _pageItem("Marzo", 2),
          _pageItem("Abril", 3),
          _pageItem("Mayo", 4),
          _pageItem("Junio", 5),
          _pageItem("Julio", 6),
          _pageItem("Agosto", 7),
          _pageItem("Septiembre", 8),
          _pageItem("Octubre", 9),
          _pageItem("Noviembre", 10),
          _pageItem("Diciembre", 11),
        ],
      ),
    );
  }
}
