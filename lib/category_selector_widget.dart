import 'package:flutter/material.dart';

class CategorySelectorWidget  extends StatefulWidget {
  final Map<String, IconData> categorias;
  final Function(String) onValueChanged;

  const CategorySelectorWidget({Key key, this.categorias, this.onValueChanged}) : super(key: key);
  
  @override
  _CategorySelectorWidgetState createState() => _CategorySelectorWidgetState();
}

class CategoryWidget extends StatelessWidget {
  final String nombre;
  final IconData icono;
  final bool selected;

  const CategoryWidget({Key key, this.nombre, this.icono, this.selected}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(
                color: selected ? Colors.blueAccent : Colors.grey,
                width: selected ? 3.0 : 1.0,
              )
            ),
            child: Icon(icono),
          ),
          Text(nombre),
        ],
      )
    );  
  }
}

class _CategorySelectorWidgetState extends State<CategorySelectorWidget> {
  String itemActual = "";

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];

    widget.categorias.forEach((nombre, icono) {
      widgets.add(GestureDetector(
        onTap: (){
          setState(() {
            itemActual = nombre;
          });
          widget.onValueChanged(nombre);
        },
        child: CategoryWidget(
          nombre: nombre,
          icono: icono,
          selected: nombre == itemActual,
        ),
      ));
    });

    return ListView(
      scrollDirection: Axis.horizontal,
      children: widgets
    );
  }
}