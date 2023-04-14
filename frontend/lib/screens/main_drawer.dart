// ignore_for_file: prefer_const_constructors

import 'package:adawati/repository/authentification_repository.dart';
import 'package:adawati/screens/Login/login_screen.dart';
import 'package:adawati/screens/Profile/profile.dart';
import 'package:adawati/screens/homepage/homepage.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
      final User? user = FirebaseAuth.instance.currentUser;
  String userName = user != null ? user.displayName ?? '' : '';
     String userEmail = user != null ? user.email ?? '' : '';
    return Drawer(
      child: Column(
        children:<Widget> [
Container(
  width: double.infinity,
  padding: EdgeInsets.all(20),
  color: Colors.blue[900],
  child: Center(
    child: Column(
      children: <Widget> [
        Container(
          width: 100,
          height: 100,
          margin: EdgeInsets.only(
            top: 30,
            bottom: 10,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: AssetImage( "assets/images/profile_pic.png",),
            fit: BoxFit.fill),
            
          ),
        ),
        Text(  
   userName,
   style: TextStyle(
   fontSize: 22,
  color: Colors.white,
 fontWeight: FontWeight.bold,),
    ),
 Text(  
    userEmail,
   style: TextStyle(
    color: Colors.white,
   fontWeight: FontWeight.normal,),
     ),
      ],
    ),
  ),
),
ListTile(
  leading: Icon(Icons.home),
  title: Text(
    "Page d'accueil",
    style: TextStyle(
      fontSize: 18,
    ),
  ),
  onTap:(){
     Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
  },
),
ListTile(
  leading: Icon(Icons.person),
  title: Text(
    'Profile',
    style: TextStyle(
      fontSize: 18,
    ),
  ),
  onTap: (){
      Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
  },
),
ListTile(
  leading: Icon(Icons.post_add),
  title: Text(
    'Don',
    style: TextStyle(
      fontSize: 18,
    ),
  ),
  onTap: null,
),
ListTile(
  leading: Icon(Icons.add_task),
  title: Text(
    'Demande',
    style: TextStyle(
      fontSize: 18,
    ),
  ),
  onTap: (){
     
  },
),
ListTile(
  leading: Icon(Icons.settings),
  title: Text(
    'Paramétres',
    style: TextStyle(
      fontSize: 18,
    ),
  ),
  onTap: null,
),
ListTile(
  leading: Icon(Icons.power_settings_new),
  title: Text(
    'Logout',
    style: TextStyle(
      fontSize: 18,
    ),
  ),
  onTap: (){
  AuthentificationRepository.instance.logout();
  print("logout");
  },
),
        ],
      ),
    );
  }
}