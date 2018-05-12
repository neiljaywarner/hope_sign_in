import 'package:flutter/material.dart';
import 'package:hope_sign_in/screens/addeditscreen.dart';

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
      home: new ListPage(title: 'HOPE Signin'),
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
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '${_counter}',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _showAddEditScreen,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


