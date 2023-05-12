import 'package:adawati/helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}
  var loginUser =FirebaseAuth.instance.currentUser;
class _ChatState extends State<Chat> {
  
  final storeMessage = FirebaseFirestore.instance;

  final auth = FirebaseAuth.instance;
  TextEditingController msg = TextEditingController();
getCurrentUser(){
  final user = FirebaseAuth.instance.currentUser;
  if(user !=null){
    loginUser =user;
  }
}
  @override
  void  initState(){
    super.initState;
    getCurrentUser();
  }
     
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kontColor,
        title: Text('Messages'),
      ),
  body:  Column(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    Expanded(
      child: Container(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          reverse: true,
          child: showMessage(),
        ),
      ),
    ),
    Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                
                top: BorderSide(color: Colors.grey, width: 0.2),
              ),
            ),
            
            child: TextField(
              controller: msg,
              decoration: InputDecoration(hintText: "Entrer Message ...."),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            if (msg.text.isNotEmpty) {
              storeMessage.collection("messages").doc().set({
                "messages": msg.text.trim(),
                "user": loginUser?.email?.toString() ?? '',
                "time": DateTime.now()
              });
              msg.clear();
            }
          },
          icon: Icon(Icons.send, color: Colors.blue),
        )
      ],
    )
  ],
),
    );
  }
}
class showMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
      .collection("messages")
      .orderBy("time")
      .snapshots(),
      builder: (context,snapshot){
if(!snapshot.hasData){
  return Center(child: CircularProgressIndicator(),
  );
}
return ListView.builder(
  itemCount: snapshot.data!.docs.length,
  shrinkWrap: true,
  primary: true,
  physics: ScrollPhysics(),
  itemBuilder: (context,i){
  QueryDocumentSnapshot x = snapshot.data!.docs[i];
  return  ListTile(
    title: Column(
      crossAxisAlignment: loginUser?.email! ==x['user']
      ? CrossAxisAlignment.end 
      : CrossAxisAlignment.start,
      children: [

        Container(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          decoration: BoxDecoration(
          color:loginUser?.email! ==x['user']? Colors.blue.withOpacity(0.2):Colors.amber.withOpacity(0.4),
          borderRadius: BorderRadius.circular(15),
          ),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(x['messages']),
              SizedBox(height: 5,),
              Text("Envoyé par :" + x['user'],
              style: TextStyle(fontSize: 10,color: Colors.grey),),
            ],
          )
        ),
      ],
    ) );

});
      },
    );
  }
}