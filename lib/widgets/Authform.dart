import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';


class Authform extends StatefulWidget {
  @override
  _AuthformState createState() => _AuthformState();
}

class _AuthformState extends State<Authform> {
  final _auth=FirebaseAuth.instance;
  var _isLoading=false;
  void _submitAuthForm(String email,String password, String username,bool isLogin,BuildContext ctx,)async{
    UserCredential authResult;
    try {
      setState(() {
        _isLoading =true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      }
      else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        FirebaseFirestore.instance.collection('users').doc(authResult.user.uid).set({
          'username':username,
          'email':email,
        });
      }
    }on PlatformException catch (err){
      var message ='An error occured,Please check your Credentials!';
      if(err.message!=null){
        message=err.message;
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(ctx).errorColor,
          ),
        );
      }
      setState(() {
        _isLoading=false;
      });
    }
    catch(err){
      print(err);
      setState(() {
        _isLoading=false;
      });
    }
  }

  var _isLogin=true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';

  final _formkey=GlobalKey<FormState>();
  void trySubmit(){
    final isValid=_formkey.currentState.validate();
    FocusScope.of(context).unfocus();
    if(isValid){
      _formkey.currentState.save();
      _submitAuthForm(_userEmail.trim(),_userPassword.trim(),_userName.trim(),_isLogin,context);

    }

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.white,
        shadowColor: Colors.lightGreenAccent,
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Form(
              key: _formkey,
              child: Column(
                //mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    key: ValueKey("email"),
                    validator: (value){
                      if (value.isEmpty || !value.contains('@') || !value.contains('gmail.com') && !value.contains('yahoo.com')){
                        return 'Hey Asshole enter a valid email';
                      }
                      return null;
                    },
                    cursorColor: Colors.deepOrangeAccent,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: 'Email Address'),
                    onSaved:(value){
                      _userEmail=value;
                    },
                  ),
                  if(!_isLogin)
                    TextFormField(
                      key: ValueKey("userName"),
                      validator: (value){
                        if (value.isEmpty || value.length<4){
                          return 'Enter atleast 4 characters';
                        }
                        return null;
                      },
                      cursorColor: Colors.deepOrangeAccent,
                      decoration: InputDecoration(labelText: "UserName"),
                      onSaved:(value){
                        _userName=value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey("Password"),
                      validator: (value){
                        if (value.isEmpty || value.length<7){
                          return 'Password must be at least 7 characters long';
                        }
                        return null;
                      },
                      cursorColor: Colors.deepOrangeAccent,
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true,
                    onSaved:(value){
                      _userPassword=value;
                    },
                  ),
                  SizedBox(height: 20),
                  if(_isLoading)
                    CircularProgressIndicator(),
                  if(!_isLoading)
                  RaisedButton(
                    child: _isLogin ? Text("Login"):Text("Signup"),
                    onPressed: trySubmit,
                  ),
                  if(!_isLoading)
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child:  _isLogin ?Text("Create a new account"):Text("I already have an account"),
                    onPressed: (){
                      setState(() {
                        _isLogin =!_isLogin;
                      });
                    },
                  )
                ],
              ),
            ),

          ),
        ),
      ),
    );
  }
}
