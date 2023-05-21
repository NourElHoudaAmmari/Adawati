import 'dart:io';
import 'package:adawati/helpers/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:adawati/repository/authentification_repository.dart';
import 'package:adawati/screens/Login/login_screen.dart';
import 'package:adawati/screens/Profile/update_screen_profile.dart';
import 'package:adawati/screens/homepage/homepage.dart';
import 'package:adawati/widget/profile_menu.dart';
import 'package:adawati/repository/user_repository.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
     final _authRepo = Get.put(AuthentificationRepository());
  final _userRepo = Get.put(UserRepository());
     String name = '';
     String email ='';
     String imageUrl = '';
 File? _imageFile;
 @override
void  initState(){
  super.initState;
   getUserData();
}
void getUserData() async {
    final userEmail = _authRepo.firebaseUser.value?.email;
    if (userEmail != null) {
      final user = await _userRepo.getUserDetails(userEmail);
      setState(() {
        name = user.name;
        email = userEmail;
        imageUrl = user.profilePick;
      });
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
          borderRadius: BorderRadius.circular(150),
          child: _imageFile != null
            ? Image.file(_imageFile!, fit: BoxFit.cover)
            : imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                      ),
                    );
                  },
                )
              : Image.asset('assets/images/profile_pic.png'),
        ),
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
               email,
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

