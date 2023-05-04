import 'package:adawati/helpers/constants.dart';
import 'package:adawati/repository/authentification_repository.dart';
import 'package:adawati/screens/Login/login_screen.dart';
import 'package:adawati/screens/Profile/update_screen_profile.dart';
import 'package:adawati/screens/homepage/homepage.dart';
import 'package:adawati/widget/profile_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user =FirebaseAuth.instance.currentUser;
  
   final CollectionReference usersRef =
      FirebaseFirestore.instance.collection("users");
     String name = '';
    // String email ='';

 @override
void initState() {
  super.initState;
  fetchUserData();
}

void fetchUserData() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    DocumentSnapshot userDoc = await usersRef.doc(currentUser.uid).get();
    Map<String, dynamic>? userData =
        userDoc.data() as Map<String, dynamic>?;
    if (userData != null) {
      setState(() {
        name = userData['name'];
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
   var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kontColor,
        leading: IconButton(
          onPressed: (){
             Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
          }, icon: const Icon(CupertinoIcons.arrowtriangle_left)),
          title: Text("Profile", style: TextStyle(color: Colors.white,fontStyle: FontStyle.italic)),
         
    
        ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset('assets/images/profile_pic.png')),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                     width: 35,
                     height: 35,
                    // decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),color: Colors.grey),
                    
                     ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
   Text(
            name,
                style: TextStyle(fontSize: 20,color: kPrimaryColor,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold)
              ),
              Text(
               (user?.email ?? ''),
                style: TextStyle(fontSize: 16,color: kontColor,fontStyle: FontStyle.normal),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateProfileScreen()));
                  },
                 // onPressed: ()=>  Get.to(()=> const UpdateProfileScreen()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    side: BorderSide.none,
                    shape: const StadiumBorder()),
                  child: const Text("Modifier Profile", style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 50),
              const Divider(),
              const SizedBox(height: 10),

              ProfileMenuWidget(title: "Paramètres",icon:CupertinoIcons.settings,onPress: (){}),
              ProfileMenuWidget(title: "Details",icon:CupertinoIcons.book,onPress: (){}),
               const Divider(color: Colors.grey),
               const SizedBox(height: 10),
               ProfileMenuWidget(title: "Informations", icon: CupertinoIcons.info, onPress: (){}),
               ProfileMenuWidget(
                title: "Se déconnecter",
                 icon: CupertinoIcons.power,
                 textColor: Colors.red,
                 endIcon: false,
                  onPress: (){
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
            ]
          ),
        ),
      ),
    );
  }
}

