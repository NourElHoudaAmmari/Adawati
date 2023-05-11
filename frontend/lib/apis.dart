import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:adawati/models/Message.dart';
import 'package:adawati/models/userModel.dart';
import 'package:adawati/screens/Signup/components/signup_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';

class APIs{
  static FirebaseStorage storage = FirebaseStorage.instance;
static User get user =>auth.currentUser!;
  static FirebaseAuth auth = FirebaseAuth.instance;
  static late UserModel me;
 
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<bool> userExists() async {
    return(await firestore.collection('users').doc(auth.currentUser!.uid).get()).exists;
  }

  static Stream<QuerySnapshot<Map<String,dynamic>>>getAllUsers(){
    return firestore.collection('users').where('id',isNotEqualTo: user.uid).snapshots();
  }


 static String getConversationID(String id)=> user.uid.hashCode <= id.hashCode
? '${user.uid}_$id'
:'${id}_${user.uid}';

    static Stream<QuerySnapshot<Map<String,dynamic>>>getMessages(UserModel user){
    return firestore.collection('chats/${getConversationID(user.id)}/messages/')
    .orderBy('sent',descending: true)
    .snapshots();
  }

  static Future<void>sendMessage(UserModel userChat,String msg, Type type)async{
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Message message = Message(toId: userChat.id,msg: msg,read: '',type: type,fromId: user.uid,sent: time);
    final ref = firestore.collection('chats/${getConversationID(userChat.id)}/messages/');
await ref.doc(time).set(message.toJson()).then((value) => sendPushNotification(userChat,type == Type.text ? msg:'image'));
  }

  static Future<void> updateMessageReadState(Message message)async{
    firestore.collection('chats/${getConversationID(message.fromId)}/messages/').doc(message.sent)
    .update({'read':DateTime.now().millisecondsSinceEpoch.toString()});

  }
  static Stream<QuerySnapshot> getLastMessage(UserModel user){
    return firestore.collection('chats/${getConversationID(user.id)}/messages/')
    .orderBy('sent',descending: true)
    .limit(1)
    .snapshots();
  }

  static Future<void> sendChatImage(UserModel userChat, File file)async{
    final ext = file.path.split('.').last;
    final ref = storage.ref().child('images/${getConversationID(userChat.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'))
    .then((p0){
      log('data transfred: ${p0.bytesTransferred /1000} kb'); 
    });
  final imageUrl = await ref.getDownloadURL();
  await sendMessage(userChat, imageUrl, Type.image);
  }


  static Stream<QuerySnapshot<Map<String,dynamic>>>getUserInfo(UserModel userChat){
    return firestore
    .collection('users')
    .where('id',isEqualTo:userChat.id)
    .snapshots();
  }
  static Future<void> updateActiveStatus(bool isOnline)async{
    firestore .collection('users').doc(user.uid).update({
      'isOnline':isOnline,
    'lastActive':DateTime.now().millisecondsSinceEpoch.toString(),
    'pushToken':me.pushToken,
    });
  }

  static Future<void> getFirebaseMessagingToken()async{
    await fMessaging.requestPermission();
    await fMessaging.getToken().then((t) {
if(t != null){
  me.pushToken = t;
}
    });
  }

  static Future<void>getSelfInfo()async{
    await firestore.collection('users').doc(user.uid).get().then((user) async{
      if(user.exists){
        me = UserModel.fromSnapshot(user.data()! as DocumentSnapshot<Map<String, dynamic>>);
       await getFirebaseMessagingToken();
      
       APIs.updateActiveStatus(true);
        log('data:${user.data()!}');
      }else{
      await createUser().then((value)=> getSelfInfo());
      }
    });
  }
  static Future<void> sendPushNotification(UserModel userChat, String msg)async{
   try{
     final body = {
      "to": userChat.pushToken,
      "notification":{
        "title":userChat.name,
        "body":msg,
      }
    };
    
var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
headers: {
  HttpHeaders.contentTypeHeader : 'application/json',
  HttpHeaders.authorizationHeader:'key=AAAAgaJq6u0:APA91bEobZq7wXXeMHKVnbVxeiKNGBY5ePAq4YIWsEeudydxFLuuRB4T78PsnSQ9dpjH3lnBB4YaTFpZFkXUAO7ewWkh8-jITeUn2VbWda3_enRQZtWketOAkgw60bEZA3kyck8kW0vn'
},
 body: jsonEncode(body));
log('Response status: ${res.statusCode}');
log('Response body: ${res.body}');
   }
   catch(e){
    log('\nsendPushNotificationE:$e');
   }
  }
  
  static  createUser() {
    SignUpForm();
  }


  static Future<void> deleteMessage(Message message)async{
    await firestore.collection('chats/${getConversationID(message.toId)}/messages/')
    .doc(message.sent)
    .delete();
    if(message.type == Type.image)
    await storage.refFromURL(message.msg).delete();
  }

    static Future<void> updateMessage(Message message, String updateMsg)async{
    await firestore.collection('chats/${getConversationID(message.toId)}/messages/')
    .doc(message.sent)
    .update({'msg':updateMsg});
    
  }
}