import 'package:flutter/material.dart';

class Computations extends StatefulWidget {
  List<String> params;
  Computations(this.params);

  @override
  _ComputationsState createState() => _ComputationsState();
}

class _ComputationsState extends State<Computations> {
  List<Widget> _calcButtons = [];
  @override
  void initState() {
    super.initState();
    for (int j = 0; j < widget.params.length; j++) {}
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
              children: <Widget>[],
            ),
          ),
        ],
      ),
    );
  }
}
