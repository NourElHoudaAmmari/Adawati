import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import'package:adawati/screens/Signup/components/socal_sign_up.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import 'package:http/http.dart' as http;
import '../../Login/login_screen.dart';
import 'package:adawati/config.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState()=> _SignUpFormState();
}
class _SignUpFormState extends State<SignUpForm>{
    
TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController =TextEditingController();
bool _isNotValidate = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String name = "", password="", email="", msg = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _scaffoldKey,
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (name) {},
            decoration: InputDecoration(
              errorText: _isNotValidate ?"Veuillez entrer UserName":null,
              hintText: "NomPrenom",
              // ignore: prefer_const_constructors
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: const Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            onSaved: (email){},
              cursorColor: kPrimaryColor,
              // ignore: prefer_const_constructors
              decoration: InputDecoration(
                   errorText: _isNotValidate ?"Veuillez entrer email adresse":null,
                hintText: "Adresse email",
                // ignore: prefer_const_constructors
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: const Icon(Icons.email),
                ),
              ),
            ),
          ),
              Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              // ignore: prefer_const_constructors
              decoration: InputDecoration(
                   errorText: _isNotValidate ?"Veuillez entrer mot passe":null,
                hintText: "Your password",
                // ignore: prefer_const_constructors
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: const Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            onPressed: ()=> {
            saveInDB()
            },
            child: Text("S`inscrire".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  saveInDB() async {
    var Url = Uri.parse('http://192.168.1.184:5000/register');
    final data = jsonEncode({
      'name': nameController.text,
      'email': emailController.text,
      'password': passwordController.text
    });
    try {
      var res = await http.post(Url,
          body: data,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      if (res.statusCode == 200) {
        msg = "success register!!";
        setState(() {
          showSnackBar(msg);
          Timer(Duration(seconds: 3),
              () => {Navigator.of(context).pushNamed("homepage")});
        });
      } else {
        msg = "failed register!!";
        setState(() {
          showSnackBar(msg);
        });
      }
    } on SocketException catch (_) {
      msg = "failed in connection";
      setState(() {
        showSnackBar(msg);
      });
    }
  }

  void showSnackBar(String msg) {
    final SnackBar snackBar = new SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}