import 'dart:developer';

import 'package:adawati/apis.dart';
import 'package:adawati/helpers/constants.dart';
import 'package:adawati/models/userModel.dart';
import 'package:adawati/widget/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
List<UserModel> list=[];
final List<UserModel> _searchList = [];
bool _isSearching = false;
@override
void get initState{
  super.initState;
  //APIs.getSelfInfo();
 // APIs.getFirebaseMessagingToken();
    APIs.updateActiveStatus(true);
  SystemChannels.lifecycle.setMessageHandler((message){
    if(APIs.auth.currentUser!=null){
 if(message.toString().contains('resume')){
 APIs.updateActiveStatus(true);
 }
    if(message.toString().contains('pause'))
    {APIs.updateActiveStatus(false);
    }
    }
return Future.value(message);
  });
}
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if(_isSearching){
            setState(() {
              _isSearching = !_isSearching;
            });
             return Future.value(false);
          }else{
 return Future.value(true);
          }
        },
        child: Scaffold(
             appBar: AppBar(
            backgroundColor: kontColor,
            title: _isSearching
            ? TextField(
              
              decoration: InputDecoration(border: InputBorder.none,hintText: 'Nom, Email ....',fillColor: kontColor,),
              autofocus: true,
             style: TextStyle(fontSize: 16,color: Colors.white),
             onChanged: (val) {
               _searchList.clear();
               for(var i in list){
                if(i.name.toLowerCase().contains(val.toLowerCase())||
                i.email.toLowerCase().contains(val.toLowerCase())){
                  _searchList.add(i);
               }
               setState(() {
                 _searchList;
               });
               }
             },
            ) 
            :Text('Messages'),
            actions: [
              IconButton(onPressed: (){
                setState(() {
                  _isSearching = !_isSearching;
                });
              }, icon: Icon(_isSearching
              ?CupertinoIcons.clear_circled_solid
              : Icons.search,))
            ],
          ),
          body: StreamBuilder (
            stream: APIs.getAllUsers(),
          builder :(context, snapshot) {
            switch(snapshot.connectionState){
              case ConnectionState.waiting:
              case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
              case ConnectionState.active:
              case ConnectionState.done:
              final data = snapshot.data!.docs;
          list = data.map((e) => UserModel.fromSnapshot(e)).toList() ?? [];
          
          if(list.isNotEmpty){
          
            return ListView.builder(
              padding: EdgeInsets.only(top: 2),
              physics: BouncingScrollPhysics(),
              itemCount: _isSearching ? _searchList.length : list.length,
              itemBuilder: (context,index){
              return ChatUserCard(user: _isSearching? _searchList[index] : list[index]);
            });
          }else{
        return Center(child: Text('Aucune connexions trouvée !',style: TextStyle(fontSize: 20),));
          }
            }  
          }, 
          ),
        ),
      ),
    );
  }
}