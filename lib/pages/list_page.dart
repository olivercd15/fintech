import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parcial1_sw1/login_state.dart';
//import 'package:parcial1_sw1/mes_widget.dart';
//import 'package:parcial1_sw1/pages/home_page.dart';
import 'package:provider/provider.dart';

class ListPage extends StatefulWidget {
  final int mesActual;

  const ListPage({Key key, this.mesActual}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginState>(
        builder: (BuildContext context, LoginState state, Widget child) {
      var user = Provider.of<LoginState>(context, listen: false).currentUser();
      var _query = Firestore.instance
          .collection('usuario')
          .document(user.uid)
          .collection('gasto')
          .where("mes", isEqualTo: widget.mesActual +1)
          .snapshots();

      return Scaffold(
        appBar: AppBar(
          title: Text("Lista de Gastos"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _query,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data){
            if(data.hasData){
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  var document = data.data.documents[index];
                  return Dismissible(
                    key: Key(document.documentID),
                    onDismissed: (direction){
                      Firestore.instance
                      .collection('usuario')
                      .document(user.uid)
                      .collection('gasto')
                      .document(document.documentID)
                      .delete();
                    },

                    child: ListTile(
                      leading: Stack(
                        children: <Widget>[
                          Icon(
                            Icons.calendar_today,
                            size: 40,
                          ),
                          Positioned(left: 15, right: 0, bottom: 10,
                            child: Text(document["dia"].toString()),
                          ),
                        ],
                      ),
                      
                      title: Text(document["valor"].toString()),
                      subtitle: Text(document["categoria"]),
                    ),
                  );
                },
                itemCount: data.data.documents.length,
              );
            }
            return Center(child: CircularProgressIndicator(),);
          }
        )
      );
    });
  }
}
