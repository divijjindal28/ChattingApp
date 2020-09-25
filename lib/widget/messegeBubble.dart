import 'package:flutter/material.dart';

class messegeBubble extends StatelessWidget {
  final String messege;
  final String userName;
  final bool isMe;
  Key key;
  final String url;
  messegeBubble(this.messege,this.isMe,this.userName,this.url,{this.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 150,
              decoration: BoxDecoration(
                  color: isMe ? Colors.grey : Theme.of(context).primaryColor,

                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft:isMe? Radius.circular(10): Radius.circular(0),
                    bottomRight :isMe ?Radius.circular(0): Radius.circular(10),
                  )
              ),
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment:isMe ? CrossAxisAlignment.end: CrossAxisAlignment.start ,
                children: <Widget>[

                  Text(userName, style :TextStyle(color: isMe ? Colors.black : Colors.white, fontWeight: FontWeight.bold) ),
                  Text(messege, style :TextStyle(color: isMe ? Colors.black : Colors.white) )
                ],),
            ),
          ],
        ),
        Positioned(
          top: 0,
          left: isMe ? null : 130,
          right: isMe ? 130:null,

          child: CircleAvatar(backgroundImage: NetworkImage(url),),

        )

      ],
      overflow:Overflow.visible,
    );
  }
}
