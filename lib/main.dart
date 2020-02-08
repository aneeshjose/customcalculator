import 'package:customcalc/add-record.dart';
import 'package:customcalc/calculate.dart';
import 'package:customcalc/core/supportclasses.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

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
  Future<List<Equations>> _savedOptions;
  List<Widget> _savedWidgets = [];

  @override
  void initState() {
    createDatabases();
    super.initState();

    _savedOptions = _loadSavedOptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Calculator"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _savedOptions = _loadSavedOptions();
              });
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          FutureBuilder(
            future: _savedOptions,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done ||
                  snapshot.connectionState == ConnectionState.none) {
                if (snapshot.hasData) {
                  _savedWidgets = [];
                  if (snapshot.data.length != 0) {
                    for (int i = 0; i < snapshot.data.length; i++) {
                      _savedWidgets.add(
                        new FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        new Calculate(snapshot.data[i])));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                // border: Border()
                                borderRadius: BorderRadius.circular(5)),
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(snapshot.data[i].name),
                            ),
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: _savedWidgets,
                    );
                  }
                  // return Text("Have prev records");
                  else
                    return Center(
                      child: FlatButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new AddRecord())),
                        child: new Text("Add new "),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0),
                            side: BorderSide(color: Colors.yellow[900])),
                      ),
                    );
                } else {
                  return Center(
                    child: FlatButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new AddRecord())),
                      child: new Text("Add new"),
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 50.0,
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => new AddRecord()));
        },
      ),
    );
  }

  Future<List<Equations>> _loadSavedOptions() async {
    List<Map> equList = [];
    List<Equations> equations = [];
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'database.db';

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      db.close();
    });
    try {
      equList = await database.rawQuery('select * from equations ');
      //
      database.close();
      //
      for (int i = 0; i < equList.length; i++) {
        equations.add(Equations(equList[i]['name'], equList[i]['equation'],
            equList[i]['variables']));
      }
      return equations;
    } catch (e) {
      database.close();

      return null;
    }
  }

  Future<void> createDatabases() async {
    try {
      var databasesPath = await getDatabasesPath();
      String path = databasesPath + 'database.db';

      Database database = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        db.close();
      });
      Batch batch = database.batch();
      batch.execute(
          'CREATE TABLE equations(name TEXT PRIMARY KEY,equation TEXT,variables TEXT)');

      // await db.execute("create table trades(trade text primary key)");
      await batch.commit();
    } catch (e) {}
  }
}
