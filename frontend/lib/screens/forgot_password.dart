import 'package:adawati/screens/Login/login_screen.dart';
import 'package:adawati/screens/forg_pass_complete.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../helpers/constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController forgetPasswordController=TextEditingController();
  @override
  void dispose(){
    forgetPasswordController.dispose();
    super.dispose();
  }
  Future passwordReset()async{
    try{
    await FirebaseAuth.instance
    .sendPasswordResetEmail(email: forgetPasswordController.text.trim());
  }on FirebaseAuthException catch (e){
    print(e);
    showDialog(
      context: context,
       builder: (context){
        return AlertDialog(
          content: Text('Mot de passe envoyé! verifier votre email'),
        );
       },
       );
  }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    elevation: 0,
    backgroundColor: kontColor,
        centerTitle: false,
        title: Text("Mot de passe oublié"),
      ),
      
      body: SingleChildScrollView(
        
        child: Container(
          child: Column(
            
            children: [
              
              Padding(
                padding: const EdgeInsets.all(40),
             child: Text('Entrez votre email et nous vous enverrons un lien de réinitialisation de mot de passe',
             textAlign: TextAlign.center,
             style: TextStyle(fontSize: 15,fontStyle: FontStyle.italic),),
              ),
              SizedBox(height: 10,),
              Container(
                padding:const EdgeInsets.all(20),
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
                height: 30,
              ),
  Container(
  width: 250,
  height: 50,
  child: MaterialButton(
    onPressed: (){
      passwordReset();
          Navigator.push(context,
    MaterialPageRoute(builder: (context) => EmailSent()),
      );
    },
    child: Text("Soumettre",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
    color: kontColor,
    textColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    
  ),
  
),

            ],
          ),
        ),
      ),
    );
  }
}