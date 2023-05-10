import 'package:adawati/apis.dart';
import 'package:adawati/helpers/my_date_util.dart';
import 'package:adawati/models/Message.dart';
import 'package:adawati/models/userModel.dart';
import 'package:adawati/screens/homepage/ChatRoom.dart';
import 'package:adawati/screens/homepage/chat.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  final UserModel user;
   const ChatUserCard({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {

Message? _message;
  @override
  Widget build(BuildContext context) {
    return 
    Card(
      margin: EdgeInsets.symmetric(horizontal:4, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatRoom(user: widget.user,)));
        },
        child: StreamBuilder(
          stream: APIs.getLastMessage(widget.user),
          builder: (context,snapshot){
            final data = snapshot.data?.docs;
            final   list = data?.map((e) => Message.fromSnapshot(e as DocumentSnapshot<Map<String, dynamic>>)).toList() ?? [];
           if(list.isNotEmpty) _message = list[0];
return ListTile(
          leading:ClipRRect(
            borderRadius:BorderRadius.circular(20),
            child:  CircleAvatar(child: Icon(CupertinoIcons.person),),
           /* child: CachedNetworkImage(
              height: 0.5,
              width: 0.5,
              imageUrl: 
               widget.user.profilePick ?? '',
                 // placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>  CircleAvatar(child: Icon(CupertinoIcons.person),),
               ),*/
          ),
       
          title: Text(widget.user.name),
          subtitle: Text(_message!=null
           ? _message!.type == Type.image
           ?'image'
           :_message!.msg
            : widget.user.email,
            maxLines: 1),


          trailing: _message == null
          ? null
           : _message!.read.isEmpty && _message!.fromId != APIs.user.uid
            
          ? Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: Colors.greenAccent.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ):Text(MyDateUtil.getLastMessageTime(context: context, time: _message!.sent),
          style: TextStyle(color: Colors.black54),
          ),

         
        );
          })
      ),
    );

}
}