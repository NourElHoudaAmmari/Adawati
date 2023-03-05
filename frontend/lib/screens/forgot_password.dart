import 'package:adawati/screens/Login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../constants.dart';

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
        title: Text("mot de passe oublié"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                padding:const EdgeInsets.all(defaultPadding),
                alignment: Alignment.center,
                height: 200.0,
                child:Lottie.asset("assets/forgetpass.json"),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                       cursorColor: kPrimaryColor,
                  controller: forgetPasswordController,
                  decoration: InputDecoration(
                          prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
           child: Icon(Icons.email_outlined,color:Color.fromARGB(255, 189, 188, 188),),
                ),
                    hintText: 'Email',
                  ),
                ),
              ),
              SizedBox(
                height: defaultPadding,
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
                child: Text("Soumettre"),
                
                style: ButtonStyle(
                  
                  backgroundColor: MaterialStateProperty.all(kontColor),
                ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}