import 'package:adawati/controllers/demande_controller.dart';
import 'package:adawati/helpers/constants.dart';
import 'package:adawati/models/demande_model.dart';
import 'package:adawati/screens/demande/demande_screen.dart';
import 'package:adawati/screens/demande/form_edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../repository/authentification_repository.dart';
import '../../repository/user_repository.dart';

class MyPopup extends StatelessWidget {
  const MyPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 100,
        height: 200,
       
      ),
    );
  }
}
 
class AddEditDemande extends StatefulWidget {
  
 final DemandeModel? demande;
final index;
AddEditDemande({this.demande, this.index,});

  @override
  State<AddEditDemande> createState() => _AddEditDemandeState();
}

class _AddEditDemandeState extends State<AddEditDemande> {
    FlutterLocalNotificationsPlugin localNotification=FlutterLocalNotificationsPlugin();
  Future _showNotification()async{
    var androidDetails = new AndroidNotificationDetails("channelId", "Local Notification",importance: Importance.high);
    var generalNotificationDetails =  new NotificationDetails(android: androidDetails);
    await localNotification.show(0, "Demande", "Une demande a été ajouté à Adawati !",generalNotificationDetails);
  }
 final _form_Key = GlobalKey<FormState>();
  bool isedit = false;
  final TextEditingController description = TextEditingController();
  final TextEditingController id = TextEditingController();

  
  //final FirebaseAuth _auth = FirebaseAuth.instance;
    String? userId;
  //String? userName;
 final _authRepo = Get.put(AuthentificationRepository());
  final _userRepo = Get.put(UserRepository());
  String name = '';
  String email = '';
  final TextEditingController nameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
  @override
void  initState(){
  super.initState;
  if(widget.index != null){
    isedit = true;
    id.text = widget.demande?.id;
    description.text = widget.demande?.description;
  } else {
    isedit = false;
  }

   nameController.text = name;
  emailController.text = email;
      var androidInitialize = new AndroidInitializationSettings('launcher_icon');
   // var iOSIntialize = new InitializationSettings();
    var initialzationSettings = new InitializationSettings(android: androidInitialize);
    localNotification = new FlutterLocalNotificationsPlugin();
    localNotification.initialize(initialzationSettings);
  }
    void getUserData() async {
    final user = _authRepo.firebaseUser.value;
    if (user != null) {
      final userEmail = user.email;
      if (userEmail != null) {
        final userModel = await _userRepo.getUserDetails(userEmail);
        setState(() {
          name = userModel.name;
          email = userEmail;
 
        });
      }
    }
  }
   @override
  Widget build(BuildContext context) {
     getUserData();
    return Scaffold(
  appBar: AppBar(
        title: Center(child: 
        
        Text(
           isedit == true ? "Modifier demande" : "Ajouter demande",
          style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
        ),
        ),
        elevation: 0.0,

        backgroundColor: kPrimaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
       Navigator.of(context).pop();
        },
        ),
        // backgroundColor: Colors.transparent,
      
      
       ),

        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
               Center(
                child: isedit == true
                 ? const Text("Modifier demande",style: TextStyle(fontSize: 28,color: kontColor,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),)
                   :const Text("Ajouter demande",style: TextStyle(fontSize: 28,color: kontColor,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),)
                
              
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                    key: _form_Key,
                    child: Column(
                      children: [
                        FormEdit(
                          labledText: "Description",
                          mycontroller: description,
                        )
                      ],
                    )),
              ),
              const SizedBox(height: 26),
            
              SizedBox(
                width: 200,
                child: ElevatedButton(
                style: ElevatedButton.styleFrom(
    backgroundColor: kontColor ,
  ),
                onPressed: () async {
  if (_form_Key.currentState!.validate()) {
    _form_Key.currentState!.save();
    final user = FirebaseAuth.instance.currentUser;
     final userId = user!= null? user.uid :null;

    if (isedit == true) {
      DemandeController().update_demande(DemandeModel(
        id: id.text,
        description: description.text,
        userId: userId,
        userName: name, 
        createdAt: DateTime.now()
      ));
    } else {
      DemandeController().add_demande(DemandeModel(
        description: description.text,
        userId: userId,
        userName: name,
        userEmail: email, 
        createdAt: DateTime.now()
      ));
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DemandeScreen()),
    );
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Demande effectuée avec succès!'),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green,
    ));
    _showNotification();
  }
},
                    child: isedit == true ?  Text("Modifier",style: TextStyle(fontSize: 20)) : Text("Publier",style: TextStyle(fontSize: 20))
                  
                    ),
              )
            ],
          ),
        )));
  }
}
