import 'package:adawati/screens/Login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController forgetPasswordController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Mot de passe oublié"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 250.0,
                child:Image.asset("assets/icons/signup.svg"),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                child: TextFormField(
                  controller: forgetPasswordController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    hintText: 'Email',
                    enabledBorder: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                onPressed: ()async{

                  var forgotEmail = forgetPasswordController.text.trim();
                   if(forgetPasswordController.text.isEmpty || !forgetPasswordController.text.contains("@")){
                 try{
               await FirebaseAuth.instance.sendPasswordResetEmail(email: forgotEmail).
                then((value) => {
                  print("Email Sent!"),
                  Get.off(()=>LoginScreen()),
                });
                 }on FirebaseAuthException catch(e){
                  print("Error $e");
                 }
                   }
                }, 
                child: Text("Réinitialiser mot de passe"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}