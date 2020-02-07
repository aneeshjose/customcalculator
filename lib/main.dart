import 'package:customcalc/add-record.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List> _savedOptions;
  @override
  void initState() {
    super.initState();
    _savedOptions = _loadSavedOptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Calculator"),
      ),
      body: FutureBuilder(
        future: _savedOptions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.none) {
            if (snapshot.hasData) {
              return Text("Have prev records");
            } else {
              return Center(
                child: FlatButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => new AddRecord())),
                  child: new Text("Add new "),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0),
                      side: BorderSide(color: Colors.yellow[900])),
                ),
              );
            }
          } else {
            // if (snapshot.connectionState == ConnectionState.active ||
            //     snapshot.connectionState == ConnectionState.waiting)

            return Text("Please wait");
          }
        },
      ),
    );
  }

  Future<List> _loadSavedOptions() async {
    return await Future.delayed(Duration(seconds: 2), () {
      // return [""];
      return null;
    });
  }
}
