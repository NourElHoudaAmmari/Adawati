// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sort_child_properties_last, avoid_returning_null_for_void, must_be_immutable, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables


import 'package:adawati/screens/Login/login_screen.dart';
import 'package:adawati/screens/main_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
 
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      
     // backgroundColor:Colors.grey[100] ,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed:(){
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF5C6BC0),
        foregroundColor: Colors.white,
       // elevation: 0,
       // shape: BeveledRectangleBorder(
         // borderRadius: BorderRadius.circular(20.0),
        //  side:BorderSide(color: Colors.blue,width: 2.0,style: BorderStyle.solid),
     // ),
    // mini: true,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Color(0xFF5C6BC0),
        child: IconTheme(
          data: IconThemeData(color: Colors.grey[100]),
         child: Padding(padding: const EdgeInsets.all(12.0),
         child: Row(
mainAxisAlignment: MainAxisAlignment.spaceAround,
children: [
  IconButton(
    
    onPressed:(){},
   icon: const Icon(Icons.home),
   ),
   IconButton(
    onPressed: (){},
    icon: const Icon(Icons.favorite_border_outlined),
    ),
    const SizedBox(width: 24),
     IconButton(
      onPressed: (){},
    icon: const Icon(Icons.chat),
    ),
     IconButton(onPressed: (){},
    icon: const Icon(Icons.person),
    ),

],
         ),
         ),
         )
      ),
      key: _key,
      
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(
          "Adawati",
          style: TextStyle(color: Colors.deepOrange[800], fontSize: 20,fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,

        backgroundColor: Colors.grey[100],
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Color.fromARGB(255, 103, 103, 103),
          ),
          onPressed: () {
            _key.currentState?.openDrawer();
          },
        ),
        // backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.notifications_none,
                color: Color.fromARGB(255, 103, 103, 103),
              ),
              onPressed: () {}),
              IconButton(
          icon: Icon(
            Icons.logout,
            color: Color.fromARGB(255, 103, 103, 103),
          ),
          onPressed: () {
          FirebaseAuth.instance.signOut().then((value) {
            print("signed out");
            Navigator.push(context, 
            MaterialPageRoute(builder: (context)=>LoginScreen()));
          });
          },
        ),
          
        ],
      ),
      body: Padding(
        
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        child: Column(
          children: [
            Container(
        child: Row(
          
          children:[
            
TextButton(onPressed: ()=>null, child: Text('Don'),

style: ButtonStyle(
  
foregroundColor: MaterialStateProperty.all(Colors.white),
backgroundColor: MaterialStateProperty.all(Colors.red),

shape: MaterialStateProperty.all<RoundedRectangleBorder>(
RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(20),
  side: BorderSide(color: Colors.red)
)
),
),),
SizedBox(width: 5,),
TextButton(onPressed: ()=>null, child: Text('Demande'),
style: ButtonStyle(
foregroundColor: MaterialStateProperty.all(Colors.red),
backgroundColor: MaterialStateProperty.all(Colors.white),
shape: MaterialStateProperty.all<RoundedRectangleBorder>(
RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(20),
  side: BorderSide(color: Colors.red)
),
),
),
),

        
                 
                ],
              ),
            ),
            
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      hintText: 'Rechercher',
                      
                      suffixIcon: Icon(
                        Icons.search,
                        color: Color.fromARGB(255, 217, 215, 215),
                      ),
                      contentPadding:
                      const EdgeInsets.only(left: 20.0, bottom: 5.0, top: 12.5),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )
                    ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: IconButton(
                    onPressed:(){}, 
                    icon: Icon(Icons.menu,
                    color: Colors.red,
                    ),
                    ),
                )
              ],
            ),
          ],
          
        ),
      ),

    );
  }
}
