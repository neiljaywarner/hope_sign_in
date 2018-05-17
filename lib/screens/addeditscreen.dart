import 'package:flutter/material.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hope_sign_in/model.dart';


class AddEditScreen extends StatefulWidget {

  final Entry entry;
  AddEditScreen(this.entry);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

//final reference = FirebaseDatabase.instance.reference().child('messages');

class _LoginPageState extends State<AddEditScreen> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  String _name;
  String _email;
  String _signIn = "";
  String _signOut = "";
  String _phone;
  String _title = "";

  bool isEditing() {
    return (widget.entry != null);
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      // Email & password matched our validation rules
      // and are saved to _email and _password fields.
      if (isEditing()) {
        _performEdit(widget.entry);
      } else {
        _performSubmit();
      }
    }
  }

  void _performEdit(Entry entry)  {
    Firestore.instance.runTransaction((transaction) async {
      await Firestore.instance.collection("Entries").document(entry.documentId).updateData(
          { 'name': _name, 'email': _email, 'phone': _phone, 'signIn': _signIn, 'signOut': _signOut }
      );
    });
    Navigator.pop(context);
  }
  void _performSubmit() {
    // This is just a demo, so no actual login here.

    if (_signIn.isEmpty) {
      _signIn = _buildNowString24HrTime();
    }
    Firestore.instance.runTransaction((transaction) async {
      // TODO: Consider if wise to use guid as reccomended. user can change id, etc.
      String documentId = _name + _phone;
      await Firestore.instance.collection('Entries').document(documentId)
          .setData({ 'name': _name,'email': _email, 'phone': _phone, 'signIn': _signIn, 'signOut': _signOut });
    });
    Navigator.pop(context);
  }

  void _initializeDefaults() {
    Entry entry = widget.entry;
    if (isEditing()) {
      _name = entry.name;
      _email = entry.email;
      _signIn = entry.signIn;
      _signOut = entry.signOut;
      _phone = entry.phone;
      _title = "Edit/Signout";

    } else {
      _title = "Add volunteer";
    }
  }

  bool isValidPhone(String val) {
    //TODO: decent phone number autoformat someday might be a nice touch...
    // see https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/material/text_form_field_demo.dart
    // as a start

    return val.length > 7
  }

  bool isValidEmail(String val) {
    if (val.isEmpty) {
      return true;
    }
    if (val.contains("@")) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _initializeDefaults();
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text(_title),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new ListView(
            children: [
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Name'),
                initialValue: _name,
                validator: (val) =>
                !(val.length > 0) ?  'Name is empty' : null,
                onSaved: (val) => _name= val,
              ),
              new TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: new InputDecoration(labelText: 'Email'),
                initialValue: _email,
                validator: (val) =>
                !isValidEmail(val) ? 'Not a valid email.' : null,
                onSaved: (val) => _email = val,
              ),
              new TextFormField(
                keyboardType: TextInputType.phone,
                decoration: new InputDecoration(labelText: 'Phone'),
                initialValue: _phone,
                validator: (val) =>
                !isValidPhone(val) ? 'Not a valid phone number' : null,
                onSaved: (val) => _phone = val,
              ),
              //TODO: Autofill with current time
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Sign In'),
                initialValue: _signIn,
                validator: (val) =>
                  isInvalidTime(val.trim())  ? 'Please use 24 hr time HH:MM' : null,
                onSaved: (val) => _signIn = val,
              ),
              //TODO: Autofill with current time
              // TODO: Decide, should it autofill with 1 hr later in some situations
              // TODO: Change to https://docs.flutter.io/flutter/material/showTimePicker.html
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Sign Out (when ready)'),
                initialValue: _signOut,
                validator: (val) =>
                isInvalidTime(val.trim())  ? 'Please use 24 hr time HH:MM' : null,
                onSaved: (val) => _signOut = val,
              ),

              new Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: new RaisedButton(
                  elevation: 8.0,
                  onPressed: _submit,
                  child: new Text('Submit'),
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
    //TODO: real time validation, eg don't allow 44:77
    // actually ,just pick from time picker

    // see when required and not
    if (val.length == 0) {
      return false;
    }
    if (val.length > 5) {
      return true;
    }

    if (val.length == 5) {
      return false;
    }

    //eg 9:22; main case
    if (val.length == 4) {
      return false;
    }

  }
}

String _buildNowString24HrTime() {
  TimeOfDay timeOfDay = new TimeOfDay.now();
  int minute = timeOfDay.minute;
  int hour = timeOfDay.hour;
  if (minute < 10) {
    return "${timeOfDay.hour}:0${timeOfDay.minute}";
  } else {
    return "${timeOfDay.hour}:${timeOfDay.minute}";
  }
}
