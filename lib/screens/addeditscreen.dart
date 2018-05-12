import 'package:flutter/material.dart';

class AddEditScreen extends StatefulWidget {
  AddEditScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AddEditScreenState createState() => new _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {

  final TextEditingController _textControllerName = new TextEditingController();
  final TextEditingController _textControllerEmail= new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var submitButton = new RaisedButton(
      elevation: 10.0,
      onPressed: () {
        Navigator.pop(context);
      },
      child: new Text('Submit'),
    );
    return new Scaffold(
      appBar: new AppBar(
        /// TODO: Change to name of volunteer when editing.
        title: new Text("Add Volunteer"),
      ),
      body: new Container(
        padding: const EdgeInsets.all(16.0),
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              'Name',
              style: Theme.of(context).textTheme.headline,
            ),
            new Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 0.0),
            child: new TextField(
              controller: _textControllerName,
            ),
            ),
            new Text(
              'Email',
              style: Theme.of(context).textTheme.headline,
            ),
            submitButton,
          ],
        ),
      ),
    );
  }
}
