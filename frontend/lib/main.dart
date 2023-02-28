//import 'package:adawati/don_add_edit.dart';
//import 'package:adawati/don_list.dart';
//import 'dart:html';

import 'package:adawati/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:adawati/constants.dart';
import 'package:adawati/screens/Welcome/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:adawati/screens/Login/login_screen.dart';
import 'package:adawati/services/shared_service.dart';
import 'package:adawati/screens/Signup/signup_screen.dart';
import 'package:adawati/screens/homepage/homepage.dart';
import 'package:adawati/services/api_service.dart';
import'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCkMtHeRa5qvup24yPS7-NL7BO9uY4QHlc",
      projectId: "adawati-7f36f",
      messagingSenderId: "556775697133",
      appId: "1:556775697133:web:5305a4060247df2b56bae4",
  ));
  runApp( MyApp());
}/* MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),*/

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final AuthService authService = AuthService();

 
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)=>MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adawati',
      theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: kPrimaryColor,
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: kPrimaryLightColor,
            iconColor: kPrimaryColor,
            prefixIconColor: kPrimaryColor,
            contentPadding: EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
          )),
          
     home:  const WelcomeScreen(),
     
     
);

}
      
















      /* routes: {
        '/':(context) => const DonList(),
          '/add-don':(context) => const DonAddEdit(),
            '/edit-don':(context) => const DonAddEdit(),
      },
    );
        theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => cont.MenuController(),
          ),
        ],
        child: MainScreen(),
      ),
    );
  }
}*/


   
  