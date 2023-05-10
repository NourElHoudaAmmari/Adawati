import 'dart:math';

import 'package:adawati/apis.dart';
import 'package:adawati/helpers/my_date_util.dart';
import 'package:adawati/models/Message.dart';
import 'package:adawati/widget/dialogs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromId;
    return InkWell(
      onLongPress: (){
_showBottomSheet(isMe);
      },
    
    child: isMe? _orangeMessage() : _blueMessage());
  }

  Widget _blueMessage(){

    if(widget.message.read.isEmpty){
      APIs.updateMessageReadState(widget.message);
     // log('message read updated');
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
            ? 10.0
            :10.0),
            margin: EdgeInsets.symmetric(horizontal: 5.0,vertical:5.0),
            decoration: BoxDecoration(color: Colors.blue[100],
            border: Border.all(color: Colors.lightBlue),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            ),
           
            child: 
            widget.message.type == Type.text ? 
            Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 15,color: Colors.black87),
            ):
        ClipRRect(
            borderRadius:BorderRadius.circular(15),
           // child:  CircleAvatar(child: Icon(CupertinoIcons.person),),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
                      height: 250, // Set the desired height
                      width: 250,
              imageUrl: widget.message.msg,
              placeholder: (context,url)=>Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(strokeWidth: 2,),
              ),
                 // placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.image,size: 70,),
               ),
          ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Text(
    MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 13,color: Colors.black54),
          ),
        ),
     
      ],
    );
  }

  Widget _orangeMessage(){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
SizedBox(width: 4,),
if(widget.message.read.isNotEmpty)
            Icon(Icons.done_all_rounded,color: Colors.blue,size: 20,),
            SizedBox(width: 3,),
            Text(
           MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 13,color: Colors.black54),
            ),
          ],
        ),

        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
            ? 10.0
            :10.0),
            margin: EdgeInsets.symmetric(horizontal: 4,vertical: 4),
            decoration: BoxDecoration(color: Colors.amber[100],
            border: Border.all(color: Colors.amber),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
            ),
           
            child:  widget.message.type == Type.text ? 
            Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 15,color: Colors.black87),
            ):
             ClipRRect(
            borderRadius:BorderRadius.circular(15),
           // child:  CircleAvatar(child: Icon(CupertinoIcons.person),),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              height:250,
              width: 250,
              imageUrl: widget.message.msg,
              placeholder: (context,url)=>Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(strokeWidth: 2,)),
                 // placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.image,size: 70,),
               ),
          ),
          ),
        ),
     
      ],
    );
  }
  void _showBottomSheet(bool isMe){
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
      ),
      builder: (_){
        return ListView(
          shrinkWrap: true,
          children: [
            Container(
height: 4,
margin: EdgeInsets.symmetric(
  vertical: 0.15,horizontal: 4
),
decoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(8)),
            ),
widget.message.type == Type.text?
          _OptionItem(icon: Icon(Icons.copy_all_rounded,color: Colors.blue,size: 26), 
          name: 'Copier le text',
           onTap: ()async{
            await Clipboard.setData(ClipboardData(text: widget.message.msg)).then((value) {
            Navigator.pop(context);
            Dialogs.showSnackBar(context, 'Text copié !');
            });
           })
           :


                    _OptionItem(icon: Icon(Icons.download_rounded,color: Colors.blue,size: 26),
                     name: 'Enregistrer image', 
                     onTap: ()async{
                      try{
                        await  GallerySaver.saveImage(widget.message.msg , albumName: 'Adawati').then((success) {
                       Navigator.pop(context);
                       if(success !=null && success){
                        Dialogs.showSnackBar(context, 'Image enregistrée !');
                       }
                       });
                      }catch(e){
                        print('errorwhilesavingimg : $e');
                      }
                     }),
         if(isMe)
          Divider(
            color: Colors.black54,
            endIndent: 4,
            indent: 4,
          ),
          if(widget.message.type == Type.text && isMe)
          _OptionItem(icon: Icon(Icons.edit,color: Colors.blue,size: 26),
           name: 'Modifier le message',
            onTap: (){
              Navigator.pop(context);
              _showMessgeUpdateDialog();
            }),
          if(isMe)
          _OptionItem(icon: Icon(Icons.delete_forever,color: Colors.red,size: 26),
           name: 'Supprimer le message',
            onTap: ()async{
              await APIs.deleteMessage(widget.message).then((value) {
                Navigator.pop(context);
              });
            }),
             Divider(
            color: Colors.black54,
            endIndent: 4,
            indent: 4,
          ),
          _OptionItem(icon: Icon(Icons.remove_red_eye,color: Colors.blue,size: 26), name: 'Envoyer à : ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}', onTap: (){}),
          _OptionItem(icon: Icon(Icons.remove_red_eye,color: Colors.green,size: 26),
           name:widget.message.read.isEmpty ? 'Lire à : pas encore vu':
           'Lire à : ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}', onTap: (){}),
          ],
        );
      });
  }
  
  void _showMessgeUpdateDialog() {
    String updateMsg = widget.message.msg;
    showDialog(context: context,
     builder: (_)=>AlertDialog(
      contentPadding: EdgeInsets.only(left: 24,right:24,top: 20,bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(
            Icons.message,
            color: Colors.blue,
            size: 28,
          ),
          Text(
            'Modifier le message'),
        ],
      ),
      content: TextFormField(
        onChanged: (value) => updateMsg = value,
        maxLines: null,
        initialValue: updateMsg,
        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
      ),
      actions: [
        MaterialButton(onPressed: (){
          Navigator.pop(context);
        },
        child: Text('Annuler',style: TextStyle(color: Colors.red,fontSize: 16),),),

                MaterialButton(onPressed: (){
                  Navigator.pop(context);
                  APIs.updateMessage(widget.message, updateMsg);
                },
        child: Text('Modifier',style: TextStyle(color: Colors.blue,fontSize: 16),),),
      ],
     ));
  }
}
class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const _OptionItem({required this.icon,required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>onTap(),
      child: Padding(
        padding: const EdgeInsets.only(left: 5,top: 15,bottom: 15),
        child: Row(
          children: [
            icon,Flexible(child: Text('    $name',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
              letterSpacing: 0.5,
            ),))
          ],
        ),
      ),
    );
  }
}