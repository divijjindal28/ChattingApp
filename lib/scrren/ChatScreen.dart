import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutterappchat/widget/chats.dart';
import 'package:flutterappchat/widget/newChat.dart';

class ChatScreen extends StatefulWidget {



  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  void initState() {
    // TODO: implement initState
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(
      onMessage: (msg){
        print(msg);
        return;
      },
      onLaunch:  (msg){
        print(msg);
        return;
      },
      onResume:  (msg){
        print(msg);
        return;
      }
    );
    fbm.subscribeToTopic('chat');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: <Widget>[
          DropdownButton(
              icon: Icon(Icons.more_vert),
              items: [
            DropdownMenuItem(
              child: Row(
                children: <Widget>[
                  Icon(Icons.exit_to_app),
                  SizedBox(width: 8,),
                  Text('LogOut')

                ],
              ),
              value: 'logout',
            )
          ], onChanged: (value){
            if(value == 'logout'){
              FirebaseAuth.instance.signOut();
            }
          })
        ],
      ),
      body:Column(children: <Widget>[
        chats(),
        newChat()
      ],) ,

    );
  }
}
