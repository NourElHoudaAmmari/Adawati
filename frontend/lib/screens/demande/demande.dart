import 'package:adawati/controllers/demande_controller.dart';
import 'package:adawati/helpers/constants.dart';
import 'package:adawati/models/demande_model.dart';
import 'package:adawati/screens/Profile/profile.dart';
import 'package:adawati/screens/demande/Add_Edit_demande.dart';
import 'package:adawati/screens/demande/EditDemandeScreen.dart';
import 'package:adawati/screens/demande/form_edit.dart';
import 'package:adawati/screens/dons/don.dart';
import 'package:adawati/screens/homepage/chat.dart';
import 'package:adawati/screens/homepage/favoirs.dart';
import 'package:adawati/screens/homepage/homepage.dart';
import 'package:adawati/screens/main_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../homepage/favoirs.dart';

class Demande extends StatefulWidget {
  const Demande({super.key});

  @override
  State<Demande> createState() => _DemandeState();
}

class _DemandeState extends State<Demande> {
  late Stream<QuerySnapshot> _stream;
 final CollectionReference _demande = FirebaseFirestore.instance.collection("demande");

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  void get initState{
     super.initState;
    //Create stream to listen to the 'items' collection
    _stream = _demande.snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed:() =>_onButtomPressed(),
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF5C6BC0),
        foregroundColor: Colors.white,
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
    
    onPressed:(){
      Navigator.push(context,
    MaterialPageRoute(builder: (context) => HomePage()),
  );
    },
   icon: const Icon(Icons.home),
   ),
   IconButton(
    onPressed: (){
         Navigator.push(context,
    MaterialPageRoute(builder: (context) => Favoirs()),
      );
    },
    icon: const Icon(Icons.favorite_border_outlined),
    ),
    const SizedBox(width: 24),
     IconButton(
      onPressed: (){
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => Chat()),
  );
      },
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
   appBar:AppBar(
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
        ],
      ),

      body:  Column(
        children: [
           Padding(
  padding: const EdgeInsets.all(8.0),
  child: Row(
    children: [
  Expanded(
  child: TextField(
   // controller: _searchController,
    onChanged: (value) {
      setState(() {
        _stream = _demande
        .where('description', isEqualTo: value)
        .snapshots();
       //_stream = _reference.where('title', isEqualTo: value).snapshots();
      });
    },
    decoration: InputDecoration(
      hintText: 'Rechercher',
      prefixIcon: Icon(Icons.search),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      
    ),
    cursorColor: Colors.grey,
    
  ),
),


  IconButton(
        onPressed: () {},
        icon: Icon(Icons.filter_list,
        color: Colors.deepOrange,),
      ),
    ],
    
  ),
  
),

 Row(
               children: [
                     TextButton(
                  onPressed: () {Navigator.push(context,
                       MaterialPageRoute(
                       builder: (context) =>HomePage()),
                        );               
                  },
                  child: Text(  'Dons',
                    style: TextStyle(fontSize:20 ,color: Colors.deepOrange[800], fontWeight: FontWeight.bold ),  ),),
                     TextButton(onPressed: () {Navigator.push(
                        context,
                       MaterialPageRoute(
                       builder: (context) =>Demande()),
                        );
                      },
                      child: Text(
                        'Demandes',
                        style: TextStyle(fontSize:20, color: kontColor, fontWeight: FontWeight.bold),
                      ),
                    ),
  ],
),

          
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                       stream: _demande.snapshots(),
                         builder: (context, AsyncSnapshot  snapshots) {
                  if (snapshots.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: kontColor),
                    );
                  }
                  if (snapshots.hasData) {
                    return ListView.builder(
                    itemCount: snapshots.data!.docs.length,
                       itemBuilder: (context, index) {
                       final DocumentSnapshot records = snapshots.data!.docs[index];
                       return Padding(
                         padding: const EdgeInsets.symmetric(vertical: 10),
                         child: Slidable(
                          
                                  
                              child: ListTile(
                                tileColor: Colors.grey[200],
                                title: Text(records["description"]),
                    
                                    ),
                                      ),
                       );
                                      },
                                              );
                                        } else {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    );
                
                  }
                
                },
              ),
              )
            ],
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
              color: Colors.white,
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
leading: Icon(Icons.post_add,color: kontColor),
title: Text('Ajouter un don',style: TextStyle(fontSize: 19,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
 onTap: ()=>{ Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>DonPage()),
  )
},
 tileColor: Colors.amber[50],
),
 Divider(thickness: 3,),
 ListTile(
 
     leading: Icon(Icons.add_task,color: kPrimaryColor,),
     
     title: Text('Ajouter une demande',style: TextStyle(fontSize: 19,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
     onTap: ()=>{ Navigator.push(context,
    MaterialPageRoute(builder: (context) => AddEditDemande()),
  )},
  tileColor: Colors.amber[50],
   ),

          ],
        );
      }
}


     

