import 'package:customcalc/core/supportclasses.dart';
import 'package:flutter/material.dart';

class Calculate extends StatefulWidget {
  Equations equations;
  Calculate(this.equations);
  @override
  _CalculateState createState() => _CalculateState();
}

class _CalculateState extends State<Calculate> {
  Equations equations;
  List<String> variables = [], _params = [];
  double result = 0.0;
  // Size size;

  @override
  void initState() {
    super.initState();
    equations = widget.equations;
    variables = equations.variables.split(',');
    print(variables);
  }

  @override
  Widget build(BuildContext context) {
    // size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(equations.name),
      ),
      body: ListView(
        children: <Widget>[
          FutureBuilder(
            builder: (context, snapshot) {
              List<Widget> _textFields = [];
              for (int k = 0; k < variables.length; k++) {
                _params.add("");
                print(_params);
                _textFields.add(
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 20),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: TextField(
                        style: TextStyle(
                          fontSize: 17.0,
                        ),
                        decoration: InputDecoration(
                          hintText: variables[k].toString(),
                          contentPadding: EdgeInsets.all(0.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (text) => _params[k] = text,
                      ),
                    ),
                  ),
                );
              }
              return Column(
                children: _textFields,
              );
            },
          ),
          Text(result.toString()),
          RaisedButton(
            child: Text("Compute"),
            onPressed: () => calculateResult(),
          )
        ],
      ),
    );
  }

  calculateResult() {}
}
