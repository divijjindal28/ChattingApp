import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class newChat extends StatefulWidget {
  @override
  _newChatState createState() => _newChatState();
}



class _newChatState extends State<newChat> {
  
  void _onMessageSend()async{
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();
    final userName = await Firestore.instance.collection('users').document(user.uid).get();
    await Firestore.instance
        .collection('chats').add({
      'text': messages,
      'time': Timestamp.now(),
      'userName':userName['userName'],
      'userImage':userName['user_image'],
      'userId':user.uid
    });
    _controller.clear();
  }
  var messages = '';
  var _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'Send Messege .. '),
            onChanged: (value){
              setState(() {
                messages = value;
              });
            },
          ),

        ),
        IconButton(icon: Icon(Icons.send), onPressed: _onMessageSend)
      ],
    );
  }
}
