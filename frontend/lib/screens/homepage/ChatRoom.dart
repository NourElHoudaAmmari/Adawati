import 'dart:developer';
import 'dart:io';

import 'package:adawati/apis.dart';
import 'package:adawati/helpers/my_date_util.dart';
import 'package:adawati/models/Message.dart';
import 'package:adawati/models/userModel.dart';
import 'package:adawati/widget/message_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatRoom extends StatefulWidget {
  final UserModel user;
  const ChatRoom({super.key, required this.user});


  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  List <Message> list = [];
  final _textController = TextEditingController();
  bool _showEmoji = false , _isUploading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
            onWillPop: () {
          if(_showEmoji){
            setState(() {
              _showEmoji = !_showEmoji;
            });
             return Future.value(false);
          }else{
 return Future.value(true);
          }
        },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              flexibleSpace:_appBar() ,
            ),
            backgroundColor: Colors.grey[50],
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder (
                            stream: APIs.getMessages(widget.user),
                          builder :(context, snapshot) {
                  switch(snapshot.connectionState){
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                    return SizedBox();
                    case ConnectionState.active:
                    case ConnectionState.done:
                   final data = snapshot.data!.docs;
                          list = data?.map((e) => Message.fromSnapshot(e)).toList() ?? [];
                      
                          if(list.isNotEmpty){
                          
                  return ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.only(top: 2),
                    physics: BouncingScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (context,index){
                    return MessageCard(message: list[index]);
                  });
                          }else{
                        return Center(child: Text('Salut! 👋',style: TextStyle(fontSize: 20),));
                          }
                  }  
                          }, 
                          ),
                ),
                if(_isUploading)
                Align(
                  alignment:Alignment.centerRight ,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                    child: CircularProgressIndicator(strokeWidth: 2,))),
                _chatInput(),
            if(_showEmoji)
            SizedBox(
              height:320,
              child: EmojiPicker(
              
          textEditingController: _textController,
          config: Config(
              bgColor: Color.fromARGB(255, 248, 248, 248),
              columns: 7,
              emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0), 
              
             
              
          ),
              
              ),
            )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _appBar(){
    return InkWell(
      onTap: (){},
      child: StreamBuilder(
        stream:APIs.getUserInfo(widget.user) ,
        builder: (context,snapshot){
           final data = snapshot.data?.docs;
            final   list = data?.map((e) => UserModel.fromSnapshot(e as DocumentSnapshot<Map<String, dynamic>>)).toList() ?? [];
        
return Row(
        children: [
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, 
          icon: Icon(Icons.arrow_back,color: Colors.black54,)),
 ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: CircleAvatar(
    backgroundImage: widget.user.profilePick.isNotEmpty
        ? CachedNetworkImageProvider(widget.user.profilePick)
        : null,
    child: widget.user.profilePick.isNotEmpty
        ? null
        : Icon(CupertinoIcons.person),
  ),
),


            SizedBox(width: 10,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(list.isNotEmpty ? list[0].name : widget.user.name,
                style: TextStyle(fontSize: 16,color: Colors.black54,fontWeight: FontWeight.w500),),
                SizedBox(height: 2,),
                              Text(
                                list.isNotEmpty
                              ? list[0].isOnline
                              ?'En ligne'
                               :MyDateUtil.getLastActiveTime(context: context, lastActive: list[0].lastActive)
                               :MyDateUtil.getLastActiveTime(context: context, lastActive: widget.user.lastActive),
                              style: TextStyle(fontSize: 13,color: Colors.black54),
                              ),

              ],
            )
        ],
      );
        }
        ),
    );
  }
  Widget _chatInput(){
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(15)),
              child: Row(
                        children: [
                    IconButton(onPressed: (){
                      FocusScope.of(context).unfocus();
                    setState(() {
                      _showEmoji = !_showEmoji;
                    });
                    }, 
                    icon: Icon(Icons.emoji_emotions,color: Colors.blueAccent,size: 25,),
                    ),
                    Expanded(
                      child: TextField(
                        onTap: (){
                          if(_showEmoji)
                          setState(() {
                            _showEmoji = !_showEmoji;
                          });
                        },
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        hintText: 'Entrer un message..',
                        hintStyle: TextStyle(color: Colors.blueAccent,),
                        border: InputBorder.none,
                      ),
                    )),
                     IconButton(onPressed: () async{
                      final ImagePicker picker = ImagePicker();

                      final List<XFile> images = await picker.pickMultiImage(imageQuality: 70);
                      for(var i in images){
                        setState(() {
                          _isUploading=true;
                        });
                      await APIs.sendChatImage(widget.user, File(i.path));
                      setState(() {
                        _isUploading=false;
                      });
                      }
                    }, 
                    icon: Icon(Icons.image,color: Colors.blueAccent,size: 26,),
                    ),
                     IconButton(onPressed: () async{
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.camera, imageQuality: 70);
                        if(image != null){
                          log('image path : ${image.path}');
                           setState(() {
                        _isUploading=true;
                      });
                           await APIs.sendChatImage(widget.user, File(image.path));
                            setState(() {
                        _isUploading=false;
                      });
                        }
                    
                    }, 
                    icon: Icon(Icons.camera_alt_rounded,color: Colors.blueAccent,size: 26,),
                    ),
                    SizedBox(width: 2,),
                        ],
              ),
            ),
          ),
          MaterialButton(onPressed: (){
            if(_textController.text.isNotEmpty){
              APIs.sendMessage(widget.user, _textController.text,Type.text);
              _textController.text = "";
            }
          },
          shape: CircleBorder(),
          color: Colors.deepOrange,
          padding: EdgeInsets.only(top: 10,bottom: 10,right: 5,left: 10),
          minWidth: 0,
          child: Icon(Icons.send,color: Colors.white,size: 28,),),
        ],
      ),
    );
  }
}