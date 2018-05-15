import 'package:flutter/material.dart';
import 'package:hope_sign_in/model.dart';
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
      home: new ListPage(title: 'HOPE Signin (tap-signout, longpress-edit)'),
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

  void _showAddScreen() {
    Navigator.push(context,
      new MaterialPageRoute(builder: (context) => new AddEditScreen(null)),);
  }

  void _showEditScreen(Entry entry) {
    Navigator.push(context, new MaterialPageRoute(
        builder: (context) => new AddEditScreen(entry)),);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new StreamBuilder(
          stream: Firestore.instance.collection('Entries').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return new ListView.builder(
              itemCount: snapshot.data.documents.length,
              padding: const EdgeInsets.only(top: 10.0),
              itemExtent: 55.0,
              itemBuilder: (context, index) =>
                  _buildListItem(context, snapshot.data.documents[index]),
            );
          }),
      floatingActionButton: new FloatingActionButton(
        onPressed: _showAddScreen,
        tooltip: 'Add Volunteer',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    String timeEntry = "";
    String signIn = document['signIn'];
    String signOut = document['signOut'];
    String name = document['name'];
    String email = document['email'];
    String phone = document['phone'];
    if (phone==null) {
      phone="";
    }
    timeEntry = signIn;
    if (signOut.isNotEmpty) {
      timeEntry += "-" + signOut;
    }
    Entry entry = Entry(document.documentID, name, phone, email, signIn,signOut);
    return new ListTile(
      key: new ValueKey(document.documentID),
      title: new Container(
        decoration: new BoxDecoration(
          border: new Border.all(color: const Color(0x80000000)),
          borderRadius: new BorderRadius.circular(5.0),
        ),
        padding: const EdgeInsets.all(10.0),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(email),
            ),
            new Text(
              timeEntry,
            ),
          ],
        ),
      ),
      onTap: () =>
          Firestore.instance.runTransaction((transaction) async {
            DocumentSnapshot freshSnap = await transaction.get(document.reference);
            await transaction.update(
                freshSnap.reference, {'signOut': _buildNowString24HrTime()});
          },
          ),
      onLongPress: () => _showEditScreen(entry),
    );
  }
} //end of class _ListPageState





  //TODO: move to utils function
String _buildNowString24HrTime() {
  TimeOfDay timeOfDay = new TimeOfDay.now();
  int minute = timeOfDay.minute;
  if (minute < 10) {
    return "${timeOfDay.hour}:0${timeOfDay.minute}";
  } else {
    return "${timeOfDay.hour}:${timeOfDay.minute}";
  }
}

/*

 */