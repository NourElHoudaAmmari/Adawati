import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  Message({
required this.fromId,
required this.toId,
required this.sent,
required this.type,
required this.msg,
required this.read,
  });

final String toId;
final String msg;
final String read;
final Type type;
final String fromId;
final String sent;

toJson(){
  return {
   "toId": toId,
   "msg": msg,
   "read": read,
   "type": type.name,
   "fromId": fromId,
   "sent": sent


    };
}

factory Message.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
  final data = document.data()!;
  return Message(
    fromId: data['fromId'],
    toId: data['toId'],
    sent: data['sent'],
    type: data['type'].toString()==Type.image.name ? Type.image : Type.text,
    msg: data['msg'],
    read: data['read'],
    
     );
}
}
enum Type{text,image}