import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chatscreen extends StatefulWidget {
  @override
  _ChatscreenState createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Equinox Hack'),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color:Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children:<Widget> [
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8,),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'logout',
              ),
            ],
            onChanged: (itemIdentifier){
              if(itemIdentifier=='logout'){
                 FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body:StreamBuilder(
          stream: FirebaseFirestore.instance.collection('chats/qalqhiuvuLD1d18MMz6F/messages').snapshots(),
          builder: (ctx,streamSnapshot){
            if(streamSnapshot.connectionState==ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );

            }
            final documents =streamSnapshot.data.docs;
            return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (ctx,index)=>Container(
                  padding: EdgeInsets.all(8),
                  child: Text(documents[index]['text']),
                )
            );
          }


      ),
    );
  }
}


