import 'package:adawati/repository/authentification_repository.dart';
import 'package:adawati/screens/Login/login_screen.dart';
import 'package:adawati/screens/Profile/profile.dart';
import 'package:adawati/screens/demande/demande_screen.dart';
import 'package:adawati/models/userModel.dart';
import 'package:adawati/screens/dons/don_list.dart';
import 'package:adawati/screens/homepage/homepage.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:adawati/repository/user_repository.dart';
import '../helpers/constants.dart';
class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);
 @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
   final _authRepo = Get.put(AuthentificationRepository());
  final _userRepo = Get.put(UserRepository());
  /* final user =FirebaseAuth.instance.currentUser;
    final CollectionReference usersRef =
      FirebaseFirestore.instance.collection("users");*/
     String name = '';
     String email ='';
       @override
  void initState () {
    super.initState;
    getUserData();
    
   // fetchUserData();
  }

  
void getUserData() async {
    final userEmail = _authRepo.firebaseUser.value?.email;
    if (userEmail != null) {
      final user = await _userRepo.getUserDetails(userEmail);
      setState(() {
        name = user.name;
        email = userEmail;
      });
    } else {
  print(name);
  print(email);
    }
  }
  @override
  Widget build(BuildContext context) {
     
    return Drawer(
      child: Column(
        children:<Widget> [
Container(
  width: double.infinity,
  padding: EdgeInsets.all(20),
  color: kontColor,
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
  name,
   style: TextStyle(
   fontSize: 22,
  color: Colors.white,
 fontWeight: FontWeight.bold,),
    ),
 Text(  
email,
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
  onTap: (){
     Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DonList()),
            );
  },
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
      Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DemandeScreen()),
            );
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
      color: Colors.red,
    ),
  ),
  onTap:  (){
                    showDialog(
                      context: context,
                      builder: (context){
                        return Container(
                          child: AlertDialog(
                            title: Text('Voulez-vous déconnectez ?'),
                            actions: [
                       TextButton(onPressed:(){
                        Navigator.pop(context);
                              }, 
                              child: Text('Non')),
                              TextButton(onPressed:(){
          print("pressed here");
          AuthentificationRepository.instance.logout().
                      then((value) {
            print("signed out");
            Navigator.push(context, 
            MaterialPageRoute(builder: (context)=>LoginScreen()));
          });
                              }, 
                              child: Text('Oui',style: TextStyle(color: kPrimaryColor),)),
                            ],
                          ),
                        );
                      });
          
                  }
),
        ],
      ),
    );
  }
}