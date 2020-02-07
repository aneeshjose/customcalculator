import 'package:flutter/material.dart';

class Computations extends StatefulWidget {
  List<String> params;
  Computations(this.params);

  @override
  _ComputationsState createState() => _ComputationsState();
}

class _ComputationsState extends State<Computations> {
  List<Widget> _calcButtons = new List<Widget>();
  String _calcString = "";
  @override
  void initState() {
    super.initState();
    print(widget.params);
    for (int j = 0; j < widget.params.length; j++) {
      _calcButtons.add(RaisedButton(
        onPressed: () {},
        child: Text(widget.params[j]),
      ));
      _calcButtons.add(Container(
        width: 10.0,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose how to compute"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 30,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[Text(_calcString)],
            ),
          ),
          Container(
            height: 50.0,
          ),
          Wrap(
            children: _calcButtons,
          )
        ],
      ),
    );
  }
}
