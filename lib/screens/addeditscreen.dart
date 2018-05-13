import 'package:flutter/material.dart';
//import 'package:firebase_database/firebase_database.dart';


class AddEditScreen extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

//final reference = FirebaseDatabase.instance.reference().child('messages');

class _LoginPageState extends State<AddEditScreen> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  String _name;
  String _email;
  String _signIn;
  String _signOut;

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      // Email & password matched our validation rules
      // and are saved to _email and _password fields.
      _performSubmit();
    }
  }

  void _performSubmit() {
    // This is just a demo, so no actual login here.
    final snackbar = new SnackBar(
      content: new Text('Name: $_name, email: $_email, Signin:$_signIn'),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text('Add/Edit'),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new Column(
            children: [
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Name'),
                validator: (val) =>
                !(val.length > 0) ?  'Name is empty' : null,
                onSaved: (val) => _name= val,
              ),
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Email'),
                validator: (val) =>
                !val.contains('@') ? 'Not a valid email.' : null,
                onSaved: (val) => _email = val,
              ),
              //TODO: Autofill with current time
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Sign In'),
                validator: (val) =>
                val.length != 5 ? 'Please use 24 hr time HH:MM' : null,
                onSaved: (val) => _signIn = val,
              ),
              //TODO: Autofill with current time
              // TODO: Decide, should it autofill with 1 hr later in some situations
              // TODO: Change to https://docs.flutter.io/flutter/material/showTimePicker.html
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Sign Out (when ready)'),
                validator: (val) =>
                isInvalidTime(val) && (val.length >0) ? 'Please use 24 hr time HH:MM' : null,
                onSaved: (val) => _signOut = val,
              ),

              new Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: new RaisedButton(
                  elevation: 8.0,
                  onPressed: _submit,
                  child: new Text('Sign In'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //todo; Make this better
  isInvalidTime(String val) {
    if (val.length == 5) {
      return false;
    } else {
      return true;
    }
  }
}

