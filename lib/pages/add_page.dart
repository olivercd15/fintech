import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parcial1_sw1/category_selector_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parcial1_sw1/login_state.dart';
import 'package:provider/provider.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String categoria;
  double valor = 0;
  String dateStr = "hoy";
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title : GestureDetector(
          onTap: (){
            showDatePicker(
              context: context, 
              initialDate: DateTime.now(), 
              firstDate: DateTime.now().subtract(Duration(days: 30)),
              lastDate: DateTime.now().add(Duration(days: 30)),
            ).then((nuevaDate) {
              if(nuevaDate != null){
                setState(() {
                  date = nuevaDate;
                  dateStr = "${date.day.toString()}-${date.month.toString()}-${date.year.toString()}";
                });
              }
            });
          },
          child: Text(
          "Categorias ($dateStr)",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        
        centerTitle: false,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        _categorySelector(),
        _valorActual(),
        _numpad(),
        _submit(),
      ],
    );
  }

  Widget _categorySelector() {
    return Container(
      height: 80.0,
      child: CategorySelectorWidget(
        categorias: {
          "Compras": Icons.shopping_cart,
          "Comida": FontAwesomeIcons.hamburger,
          "Bebida": FontAwesomeIcons.beer,
          "Otros": FontAwesomeIcons.wallet,
        },
        onValueChanged: (nuevaCategoria) => categoria = nuevaCategoria,
      ),
    );
  }

  Widget _valorActual() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Text(
          "\Bs ${valor.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: 50.0,
            color: Colors.blueAccent,
            fontWeight: FontWeight.w500,
          ),
        ));
  }

  Widget _num(String text, double height) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            valor = valor * 10 + int.parse(text);
          });
        },
        child: Container(
          height: height,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 40,
                color: Colors.grey,
              ),
            ),
          ),
        ));
  }

  Widget _numpad() {
    return Expanded(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        var height = constraints.biggest.height / 4;

        return Table(
          border: TableBorder.all(
            color: Colors.grey,
            width: 1.0,
          ),
          children: [
            TableRow(children: [
              _num("1", height),
              _num("2", height),
              _num("3", height),
            ]),
            TableRow(children: [
              _num("4", height),
              _num("5", height),
              _num("6", height),
            ]),
            TableRow(children: [
              _num("7", height),
              _num("8", height),
              _num("9", height),
            ]),
            TableRow(children: [
              _num("", height),
              _num("0", height),
              GestureDetector(
                onTap: () {
                  setState(() {
                    valor = valor ~/ 10 + (valor - valor.toInt());
                  });
                },
                child: Container(
                  height: height,
                  child: Center(
                    child: Icon(
                      Icons.backspace,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ]),
          ],
        );
      }),
    );
  }

  Widget _submit() {
    return Builder(builder: (BuildContext context) {
      return Container(
        height: 50.0,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.blueAccent),
        child: MaterialButton(
          child: Text(
            "Añadir Gasto",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          onPressed: () {
            var user = Provider.of<LoginState>(context, listen: false).currentUser();
            if (valor > 0 && categoria != "") {
              Firestore.instance
              .collection('usuario')
              .document(user.uid)
              .collection('gasto')
              .document()
              .setData({
                "categoria": categoria,
                "valor": valor,
                "mes": date.month,
                "dia": date.day,
              });
              
              Navigator.of(context).pop();
            } else {
              Scaffold.of(context).showSnackBar(
                SnackBar(content: Text("Elige un valor y una categoria"))
              );
            }
          },
        ),
      );
    });
  }
}
