import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Chatscreen extends StatefulWidget {
  @override
  _ChatscreenState createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:StreamBuilder(
          stream: FirebaseFirestore.instance.collection('chats/tFu2GNS0PDF121ssOI0J/messages').snapshots(),
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


