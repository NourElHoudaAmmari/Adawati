// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Signup/signup_screen.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState()=> _LoginFormState();
}
class _LoginFormState extends State<LoginForm>{
TextEditingController emailController = TextEditingController();
TextEditingController passwordController =TextEditingController();
bool _isNotValidate = false;
 String name="", password="", email="", msg = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _scaffoldKey,
      child: Column(
        children: [
          TextFormField(
                      controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: InputDecoration(
              hintText: "Adresse email",
                    errorText: _isNotValidate ?"Veuillez entrer email adresse":null,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
                
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
              decoration: InputDecoration(
                hintText: "Mot de passe",
                      errorText: _isNotValidate ?"Veuillez entrer email adresse":null,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () {
                   connectionWithDB();
              },
              style:ButtonStyle(
backgroundColor: MaterialStateProperty.all(kontColor),
              ),
              child: Text(
                "Se Connecter".toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
    connectionWithDB() async {
    var Url = Uri.parse('http://10.0.2.2:3000/api/login');
    var data =
        jsonEncode({'email': emailController.text, 'password': passwordController.text});
    var head = {'Content-Type': 'application/json; charset=UTF-8'};

    try {
      var res = await http.post(Url, body: data, headers: head);

      res.statusCode == 200
          ? {
              setState(() {
                msg = 'success';
                showSnackBar(msg);
                Timer(
                    Duration(seconds: 3),
                    () => {
                          Navigator.of(context).pushReplacementNamed("homepage")
                        });
              })
            }
          : {
              setState(() {
                msg = 'failure';
                showSnackBar(msg);
              })
            };
    } on SocketException catch (_) {
      msg = "failed in connection";
      setState(() {
        showSnackBar(msg);
      });
    }
  }

  void showSnackBar(String msg) {
    SnackBar snackBar = new SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  
}