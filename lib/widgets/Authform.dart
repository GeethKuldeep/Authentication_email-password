import 'package:flutter/material.dart';

class Authform extends StatefulWidget {
  @override
  _AuthformState createState() => _AuthformState();
}

class _AuthformState extends State<Authform> {

  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';

  final _formkey=GlobalKey<FormState>();
  void trySubmit(){
    final isValid=_formkey.currentState.validate();
    FocusScope.of(context).unfocus();
    if(isValid){
      _formkey.currentState.save();
      print(_userEmail);
      print(_userName);
      print(_userPassword);

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
                  TextFormField(
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
                  RaisedButton(
                    child: Text("Login"),
                    onPressed: trySubmit,
                  ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text("Create a new account"),
                    onPressed: (){},
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
