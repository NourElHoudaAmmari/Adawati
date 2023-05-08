import 'package:flutter/material.dart';
import 'package:adawati/models/user.dart';
class UserProvider extends ChangeNotifier{
User _user = User(
  id: '',
   name: '',
    email: '',
   phone: '', 
   address: '',
    password: '', 
    profilePick: '',
      
);

 User get user => _user;

 /* void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }*/

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}