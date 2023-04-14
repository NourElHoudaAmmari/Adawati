// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sort_child_properties_last, avoid_returning_null_for_void, must_be_immutable, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:adawati/helpers/constants.dart';
import 'package:adawati/repository/authentification_repository.dart';
import 'package:adawati/screens/Login/login_screen.dart';
import 'package:adawati/screens/Profile/profile.dart';
import 'package:adawati/screens/demande/Add_Edit_demande.dart';
import 'package:adawati/screens/dons/add_don.dart';
import 'package:adawati/screens/main_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    super.initState;
    //Create stream to listen to the 'items' collection
    _stream = FirebaseFirestore.instance.collection('dons').snapshots();
  }
 final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    List<String> docIDs = [];
    Future getDocId()async{
      await FirebaseFirestore.instance.collection('users').get().then(
        (snapshot) =>snapshot.docs.forEach((document) {
          print(document.reference);
          docIDs.add(document.reference.id);
        },
        ),
        );
    }
   @override
    void initState(){
getDocId();
super.initState;
    }
    return Scaffold(
     // backgroundColor:Colors.grey[100] ,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed:() =>_onButtomPressed(),
        child: Icon(Icons.add),
        backgroundColor: kontColor,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: kontColor,
        child: IconTheme(
          data: IconThemeData(color: Colors.grey[100]),
         child: Padding(padding: const EdgeInsets.all(12.0),
         child: Row(
mainAxisAlignment: MainAxisAlignment.spaceAround,
children: [
  IconButton(
    onPressed:(){
      Navigator.push(context,
    MaterialPageRoute(builder: (context) => HomePage()),
  );
    },
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
     IconButton(onPressed: (){
      Navigator.push(context,
    MaterialPageRoute(builder: (context) => ProfileScreen()),
  );
     },
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
           AuthentificationRepository.instance.logout();
  print("logout");
          },
        ),
          
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //Check error
          if (snapshot.hasError) {
            return Center(child: Text('Some error occurred ${snapshot.error}'));
          }

          //Check if data arrived
          if (snapshot.hasData) {
            //get the data
            QuerySnapshot querySnapshot = snapshot.data;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;

            //Convert the documents to Maps
            List<Map> items = documents.map((e) => e.data() as Map).toList();

            //Display the grid
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, //Number of columns
                childAspectRatio: 0.7, //Ratio of height to width of each grid item
              ),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                //Get the item at this index
                Map thisItem = items[index];
                //Return the widget for the grid item
                return Card(
                  child: Column(
                    children: [
                      Expanded(
                        child: thisItem.containsKey('image')
                            ? Image.network('${thisItem['image']}')
                            : Placeholder(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${thisItem['title']}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          //Show loader
          return Center(child: CircularProgressIndicator());
        },
      ),
      
    );
  }
void _onButtomPressed(){
      showModalBottomSheet(
     
        context: context, 
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 180,
            child:Container(
            child: _buildBottomNavigationMenu(),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
              ),
            ),
            ),
          );
          
        }); 
     }
     
     Column _buildBottomNavigationMenu (){
      return Column(
          children:<Widget> [
ListTile(
leading: Icon(Icons.post_add),
title: Text('Ajouter un don'),
 onTap: ()=>{ Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AddDon()),
  )
},
),
 Divider(thickness: 2,),
 ListTile(
     leading: Icon(Icons.add_task),
     title: Text('Ajouter une demande'),
     onTap: ()=>{ Navigator.push(context,
    MaterialPageRoute(builder: (context) => AddEditDemande()),
  )},
   ),

          ],
        );
      }
}

