import 'dart:math';

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
  List<String> variables = [];
  String result = "";
  Map<String, String> equMap = {};
  List<String> equList = [];

  // List<String> postfix = [];
  List<String> stack = [];
  List<String> operands = [];
  List priorityList = ['-', '+', '/', '*', '^'];

  int top = -1;

  // Size size;

  @override
  void initState() {
    super.initState();
    equations = widget.equations;
    variables = equations.variables.split(',');
    equList = equations.equation.split(',');
    //
    // priorityList = priorityList.reversed;
    //
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
                // _params.add("");
                //
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
                        onChanged: (text) => equMap[variables[k]] = text,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text("Result: $result")),
          ),
          RaisedButton(
            child: Text("Compute"),
            onPressed: () => calculateResult(),
          )
        ],
      ),
    );
  }

  calculateResult() async {
    List postfix = [];
    List replaced = [];
    stack = [];
    top = -1;
    postfix = convertToPostfix();

    replaced = replaceVariables(postfix);
    //
    double res = calculate(replaced);
    //
    setState(() {
      result = res.toString();
    });
    //
  }

  List convertToPostfix() {
    List postfix = [];
    for (int i = 0; i < equList.length; i++) {
      if (equMap.containsKey(equList[i])) {
        postfix.add(equList[i]);
      } else if (priorityList.contains(equList[i])) {
        if (top > -1)
          while (stack.length != 0 &&
              priority(equList[i]) < priority(stack[top]) &&
              stack[top] != "(") {
            postfix.add(pop());
          }
        push(equList[i]);
      } else if (equList[i] == '(') {
        push('(');
      } else if (equList[i] == ')') {
        if (top > 0)
          while (stack[top] != '(') {
            postfix.add(pop());
          }
        pop();
      }
    }
    while (top > -1) {
      postfix.add(pop());
    }
    return postfix;
  }

  List replaceVariables(List postfix) {
    for (int i = 0; i < postfix.length; i++) {
      if (equMap.containsKey(postfix[i])) {
        postfix[i] = equMap[postfix[i]];
      }
    }
    return postfix;
  }

  double calculate(List replaced) {
    double res = 0.0;
    for (int i = 0; i < replaced.length; i++) {
      if (priorityList.contains(replaced[i])) {
        try {
          res =
              computeRes(replaced[i], double.parse(pop()), double.parse(pop()));
          push(res.toString());
        } catch (e) {}
      } else {
        push(replaced[i]);
      }
    }

    return double.parse(pop());
  }

  double computeRes(String operate, double oper1, double oper2) {
    try {
      if (operate == '+') return oper2 + oper1;
      if (operate == '-') return oper2 - oper1;
      if (operate == '/') return oper2 / oper1;
      if (operate == '*') return oper2 * oper1;
      if (operate == '^') return pow(oper2, oper1);
    } catch (e) {
      setState(() {
        result = e;
      });
    }
  }

  int priority(String s) {
    return priorityList.indexOf(s);
  }

  push(String s) {
    stack.add(s);
    top = stack.length - 1;
  }

  String pop() {
    top = stack.length - 2;
    return stack.removeLast();
  }
}
// class StrToD{
//   double
// }
