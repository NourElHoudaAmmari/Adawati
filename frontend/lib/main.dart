import 'package:adawati/don_add_edit.dart';
import 'package:adawati/don_list.dart';
import 'package:flutter/material.dart';
import 'package:adawati/constants.dart';
import 'package:adawati/controllers/MenuController.dart'as cont;
import 'package:adawati/screens/main/main_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adawati',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
       /* theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),*/
    /*  home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => cont.MenuController(),
          ),
        ],
        child: MainScreen(),*/
        routes: {
        '/':(context) => const DonList(),
          '/add-don':(context) => const DonAddEdit(),
            '/edit-don':(context) => const DonAddEdit(),
      },
    
    );
  }
}
