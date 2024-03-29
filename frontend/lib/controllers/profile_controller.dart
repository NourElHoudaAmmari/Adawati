

import 'dart:io';

import 'package:adawati/models/userModel.dart';
import 'package:adawati/repository/authentification_repository.dart';
import 'package:adawati/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController{
  static ProfileController get instance =>Get.find();
  var isProfilPicPathSet = false.obs;
  var profilePicPath = "".obs;


//repositories
  final _authRepo = Get.put(AuthentificationRepository());
  final _userRepo = Get.put(UserRepository());

  getUserData(){
final email = _authRepo.firebaseUser.value?.email;
if(email !=null){
 return _userRepo.getUserDetails(email);
}else{
  Get.snackbar("Erreur", "Login pour continuer");
}
  }
  Future<List<UserModel>> getAllUser()async{
    return await _userRepo.allUser();
  }

  updateRecord(UserModel user)async{
    await _userRepo.updateUserRecord(user);
  }
  uploadImage(File image)async{
    await _userRepo.uploadImageToFirebaseStorage(image);
  }

  void setProfileImagePath(String path){
    profilePicPath.value = path;
    isProfilPicPathSet.value = true;
  }



}