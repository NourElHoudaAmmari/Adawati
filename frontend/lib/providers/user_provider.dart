import 'package:flutter/material.dart';
import 'package:adawati/models/userModel.dart';
class UserProvider extends ChangeNotifier{
UserModel _user = UserModel(
  id: '',
   name: '',
    email: '',
   phone: '', 
   address: '',
    password: '', 
    profilePick: '',
    pushToken: '',
    lastActive: '',
      
);

 UserModel get user => _user;

 /* void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }*/

  void setUserFromModel(UserModel user) {
    _user = user;
    notifyListeners();
  }
}