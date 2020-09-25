import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterappchat/widget/messegeBubble.dart';


class chats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child:FutureBuilder (
          future: FirebaseAuth.instance.currentUser(),
          builder: (ctx,dataSnap) {
            if (dataSnap.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            if(!dataSnap.hasData){return null;}

              return StreamBuilder(
                  stream: Firestore.instance
                      .collection('chats').orderBy('time',descending: true)
                      .snapshots(),
                  builder: (ctx, streamSnapshot) {

                    if (streamSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if(!streamSnapshot.hasData){return Text('no messeges');}
                    var document = streamSnapshot.data.documents;
                    return ListView.builder(
                        reverse: true,
                        itemCount: document.length,
                        itemBuilder: (ctx, index) =>
                            Container(
                              child: messegeBubble(
                                  document[index]['text'],
                                  document[index]['userId'] == dataSnap.data.uid,
                                  document[index]['userName'],
                                  document[index]['userImage'],
                                  key:ValueKey( document[index].documentID),
                              ),

                            ));
                  });

          }
        )
    );
  }
}
