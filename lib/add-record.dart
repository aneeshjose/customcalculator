import 'package:customcalc/computations.dart';
import 'package:flutter/material.dart';

class AddRecord extends StatefulWidget {
  @override
  _AddRecordState createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  List<TextEditingController> _controllers = [];
  List<Widget> _computeParams = new List<Widget>();
  List<String> _params = [];
  @override
  void initState() {
    super.initState();
    _addNewField(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create new Record"),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: _computeParams,
          ),
          FlatButton(
              child: Text("Done"),
              onPressed: () {
                // print(_params);
                bool isAllNull = true;
                for (int j = 0; j < _controllers.length; j++) {
                  if (_controllers[j] != null) {
                    if (_controllers[j].text != null) {
                      isAllNull = false;
                      break;
                    }
                  }
                }

                if (!isAllNull)
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new Computations(_params)));
                else
                  print("Enter at least one field");
              }),
        ],
      ),
    );
  }

  void _addNewField(int i) {
    _params.add("");
    _controllers.add(new TextEditingController());
    setState(() {
      _computeParams.add(
        Row(
          children: <Widget>[
            Container(
              width: 200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                  onChanged: (text) => _params[i] = text,
                ),
              ),
            ),
            new IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _addNewField(i + 1);
              },
            ),
            new IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                // print(i);
                _removeField(i);
              },
            ),
          ],
        ),
      );
    });
  }

  void _removeField(int i) {
    setState(() {
      _computeParams[i] = new Container();
      _params[i] = null;
      _controllers[i] = null;
    });
    print("${_computeParams.length},${_params.length},${_controllers.length}");
  }
}
