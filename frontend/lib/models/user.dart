import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
class User{
  final String? id;
   final String name;
    final String email;
final String phone;
final String? address;
      final String? password;
      final String? profilePick;
      final bool? isBlocked;

  User({
     this.id,
   required  this.name,
     required this.email, 
     required this.phone, 
     required this.address, 
    required  this.password,
    this.profilePick,
    this.isBlocked=false,
    
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

    };
}

factory User.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
  final data = document.data()!;
  return User(
    id:document.id,
    email:data["email"],
    password: data["password"],
    name: data["name"],
    phone: data["phone"],
      address: data["address"],
            profilePick: data["profilePick"],
              // isBlocked: data["isBlocked"],
     );
}
    
}