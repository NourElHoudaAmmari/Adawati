import 'package:adawati/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';


class WhishListService{
  CollectionReference dons = FirebaseFirestore.instance.collection('dons');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  auth.User? user = auth.FirebaseAuth.instance.currentUser;

  updateFavourite(context,_isLiked,donId){
    if(_isLiked){
      
   dons.doc(donId).update({
 'favourites':FieldValue.arrayUnion([user!.uid]),

      });
       ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text('Ajouté au favoirs'),
    ),
    );
    }else{
     dons.doc(donId).update({
        'favourites': FieldValue.arrayRemove([user!.uid]),
      });
         ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text('Retiré au favoirs'),
    ),
    );
    }
  }
 
}