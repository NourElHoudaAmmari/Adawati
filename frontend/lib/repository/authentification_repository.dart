

import 'package:adawati/screens/Login/login_screen.dart';
import 'package:adawati/screens/Welcome/welcome_screen.dart';
import 'package:adawati/screens/homepage/homepage.dart';
import 'package:adawati/screens/signup_email_password_failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthentificationRepository extends GetxController{
  static AuthentificationRepository get instance => Get.find();
  final  _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
   var isLoading = false.obs;

  @override
  void onReady(){
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);

  }

  _setInitialScreen(User? user){
    user == null ? Get.offAll(()=> const WelcomeScreen()): Get.offAll(()=>HomePage());
  }

  Future<void> createUserWithEmailAndPassword(String email,String password)async{
   
      await _auth.createUserWithEmailAndPassword(email: email, password: password)
   .then((value) {
      isLoading(false);

      /// Navigate user to profile screen
      Get.to(() => LoginScreen());
    }).catchError((e) {
      /// print error information
      print("Error in authentication $e");
      isLoading(false);
    });
  }
  

   Future<void> loginWithEmailAndPassword(String email,String password)async{
  
      await _auth.signInWithEmailAndPassword(email: email, password: password)
   .then((value) {
      isLoading(false);

      /// Navigate user to profile screen
      Get.to(() => HomePage());
    }).catchError((e) {
      /// print error information
      print("Error in authentication $e");
      isLoading(false);
    });
  }
  

Future<void> logout() async {
  print('Logout button pressed');
  await _auth.signOut();
}
}