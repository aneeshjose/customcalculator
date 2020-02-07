import 'package:customcalc/add-record.dart';
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
  Future<List> _savedOptions;

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
          FlatButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => new AddRecord())),
            child: new Text(
              "Add new",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.green[600],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0),
                side: BorderSide(color: Colors.black)),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _savedOptions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.none) {
            if (snapshot.hasData) {
              if (snapshot.data.length != 0)
                return Text("Have prev records");
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
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => new AddRecord())),
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
    );
  }

  Future<List> _loadSavedOptions() async {
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
      print(equList);
      database.close();
      // print("Future done");
      for (int i = 0; i < equList.length; i++) {
        equations.add(Equations(equList[i]['name'], equList[i]['equation']));
      }
      return equations;
    } catch (e) {
      database.close();
      print(e);
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
          'CREATE TABLE if not exists equations(name TEXT PRIMARY KEY,equation TEXT)');

      // await db.execute("create table trades(trade text primary key)");
      await batch.commit();
    } catch (e) {
      print(e);
    }
  }
}

class Equations {
  String name;
  String equation;
  Equations(this.name, this.equation);
}
