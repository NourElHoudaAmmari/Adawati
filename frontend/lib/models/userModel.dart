import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
class UserModel{
final String id;
final String name;
final String email;
final String phone;
final String? address;
final String? password;
final String profilePick;
final bool isBlocked;
final bool isOnline;
final String lastActive;
late String pushToken;

     
 static UserModel? currentUser;
  UserModel({
    required this.id,
   
   required  this.name,
     required this.email, 
     required this.phone, 
     required this.address, 
    required  this.password,
      required this.profilePick,
    this.isBlocked=false,
    this.isOnline=false,
    required this.lastActive,
    required this.pushToken,
  
    
     });

toJson(){
  return {
    "name":name,
  "email":email,
   "phone":phone,
   "address":address,
    "password":password,
      "profilePick":profilePick,
       "isBlocked":isBlocked,
              "id":id,
              "isOnline":isOnline,
              "lastActive":lastActive,
              "pushToken":pushToken,
       

    };
}

factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
  final data = document.data()!;
  return UserModel(
    id:document.id,
    email:data["email"],
    password: data["password"],
    name: data["name"],
    phone: data["phone"],
      address: data["address"],
            profilePick: data["profilePick"],
            isBlocked: data["isBlocked"],
            isOnline: data["isOnline"],
                lastActive:data["lastActive"]??'',
                pushToken:data["pushToken"]??'',
     );
}
    
}