import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  var _userEmail = '';
  var _userPassword = '';
  var _userName = '';
  var _isLogin = true;
  var _isLoading = false;
  var _form = GlobalKey<FormState>();
  File _image;


  void _submitForm() async {
    var valid = _form.currentState.validate();
    if (valid) {
      _form.currentState.save();
      print('x');
      final _auth = FirebaseAuth.instance;
      AuthResult _authResult;
      setState(() {
        _isLoading = true;
      });
      try {
        if (_isLogin) {
          print('a');
          _authResult = await _auth.signInWithEmailAndPassword(
              email: _userEmail, password: _userPassword);
          print('b');
        } else {
          _authResult = await _auth.createUserWithEmailAndPassword(
              email: _userEmail, password: _userPassword);

          final ref =  FirebaseStorage.instance.ref().child('user_image').child(_authResult.user.uid + ".jpg");
          await ref.putFile(_image).onComplete;
          final url = await ref.getDownloadURL();

          await Firestore.instance
              .collection('users')
              .document(_authResult.user.uid)
              .setData(
              {'userName': _userName,
                'email': _userEmail,
                'user_image': url
              });


        }
      } catch (err) {
        var msg = 'Sorry something went wrong!';
        print(msg);
        if (err.message != null) {
          msg = err.message;
        }
        print(msg);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _takeImage() async {
    var _myimage = await ImagePicker().getImage(source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150
    );
    setState(() {
      _image = File(_myimage.path
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Form(
                key: _form,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (!_isLogin)
                      Column(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                _image != null ? FileImage(_image) : null,
                          ),
                          FlatButton.icon(
                              onPressed: _takeImage,
                              icon: Icon(
                                Icons.image,
                                color: Theme.of(context).primaryColor,
                              ),
                              label: Text(
                                'Take Image',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              )),
                        ],
                      ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: 'Email'),
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Please enter valid email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userEmail = value.trim();
                      },
                    ),
                    if (_isLogin == false)
                      TextFormField(
                        decoration: InputDecoration(labelText: 'User Name'),
                        key: ValueKey('userName'),
                        validator: (value) {
                          if (value.length < 7) {
                            return 'Please enter userName of more than 7 char long';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _userName = value.trim();
                        },
                      ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: 'Password'),
                      key: ValueKey('password'),
                      obscureText: true,
                      validator: (value) {
                        if (value.length < 7) {
                          return 'Please enter userName of more than 7 char long';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userPassword = value.trim();
                      },
                    ),
                    _isLoading
                        ? CircularProgressIndicator()
                        : RaisedButton(
                            child: Text(_isLogin ? 'Login' : 'Sign up'),
                            onPressed: _submitForm),
                    FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        child:
                            Text(!_isLogin ? 'Login Instead' : 'Sign up Instead'),
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
