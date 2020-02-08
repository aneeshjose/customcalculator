import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class SetEquation extends StatefulWidget {
  List<String> params;
  SetEquation(this.params);

  @override
  _SetEquationState createState() => _SetEquationState();
}

class _SetEquationState extends State<SetEquation> {
  List<Widget> _calcButtons = new List<Widget>();
  String _calcString = "";
  String _storeString = "";
  List<String> params;
  String _variable = "";

  String compName;

  String _errorMeassage = "";
  BuildContext scaffoldContext;

  @override
  void initState() {
    super.initState();
    params = widget.params;
    // print(params);

    for (int k = 0; k < params.length; k++)
      if (params[k] != null)
        _variable += (_variable.length == 0) ? params[k] : (',' + params[k]);

    List<String> calcParams = [
      "(",
      ")",
      "+",
      "-",
      "*",
      "/",
      '^',
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "0"
    ];
    params = params + calcParams;

    for (int j = 0; j < params.length; j++) {
      _calcButtons.add(RaisedButton(
        onPressed: () {
          setState(() {
            _calcString += params[j];
            _storeString +=
                (_storeString.length == 0) ? params[j] : (',' + params[j]);
            print(_storeString);
          });
        },
        child: Text(params[j]),
      ));
      _calcButtons.add(Container(
        width: 10.0,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Equation for calculation"),
      ),
      body: Builder(
        builder: (context) => ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[Text(_calcString)],
                        ),
                      ),
                    ),
                    Container(
                      height: 20.0,
                    ),
                    Wrap(
                      children: <Widget>[
                        Wrap(
                          children: _calcButtons,
                        ),
                        // Wrap(
                        //   children: <Widget>[],
                        // )
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            width: 200,
                            // height: 30,
                            child: Text(_errorMeassage),
                          ),
                        ),

                        Container(
                          width: 190,
                          child: TextField(
                            style: TextStyle(
                              fontSize: 17.0,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (text) => compName = text,
                          ),
                        ),
                        Container(
                          width: 10,
                        ),
                        RaisedButton(
                          onPressed: () async {
                            // print(context);
                            if (compName == null || compName == '') {
                              setState(() {
                                _errorMeassage =
                                    "Enter a name for the equation";
                              });
                            } else if (_calcString == '') {
                              setState(() {
                                _errorMeassage =
                                    "Enter the equation for calculation";
                              });
                            } else {
                              var databasesPath = await getDatabasesPath();
                              String path = databasesPath + 'database.db';
                              Database database = await openDatabase(path,
                                  version: 1,
                                  onCreate: (Database db, int version) async {
                                db.close();
                              });
                              try {
                                Batch batch = database.batch();
                                batch.insert('equations', {
                                  'name': compName,
                                  'equation': _storeString,
                                  'variables': _variable
                                });

                                await batch.commit(noResult: true);

                                print("Done");
                                // print(context);
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text("Added"),
                                  duration: Duration(seconds: 1),
                                ));
                                Future.delayed(
                                    Duration(seconds: 2, milliseconds: 500),
                                    () {
                                  Navigator.pop(context);
                                  // print("POP");
                                  Navigator.pop(context);
                                });
                              } catch (e) {
                                setState(() {
                                  _errorMeassage =
                                      "The name entered already exists Try a new one";
                                });
                                print(e);
                              }
                            }
                          },
                          child: Text("Save"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
