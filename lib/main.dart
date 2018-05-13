import 'package:flutter/material.dart';
import 'package:hope_sign_in/screens/addeditscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'HOPE Signin',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new ListPage(title: 'HOPE Sijjgnin'),
    );
  }
}

class ListPage extends StatefulWidget {
  ListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListPageState createState() => new _ListPageState();
}

class _ListPageState extends State<ListPage> {
  int _counter = 0;

  void _showAddEditScreen() {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new AddEditScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new StreamBuilder(
          stream: Firestore.instance.collection('baby').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return new ListView.builder(
                itemCount: snapshot.data.documents.length,
                padding: const EdgeInsets.only(top: 10.0),
                itemExtent: 25.0,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.documents[index];
                  return new Text(" ${ds['name']} ${ds['votes']}");
                }
            );
          }),
      floatingActionButton: new FloatingActionButton(
        onPressed: _showAddEditScreen,
        tooltip: 'Add Volunteer',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


