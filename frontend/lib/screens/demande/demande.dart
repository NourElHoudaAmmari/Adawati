import 'package:adawati/controllers/demande_controller.dart';
import 'package:adawati/helpers/constants.dart';
import 'package:adawati/models/demande_model.dart';
import 'package:adawati/screens/Profile/profile.dart';
import 'package:adawati/screens/demande/Add_Edit_demande.dart';
import 'package:adawati/screens/demande/EditDemandeScreen.dart';
import 'package:adawati/screens/demande/form_edit.dart';
import 'package:adawati/screens/dons/don.dart';
import 'package:adawati/screens/homepage/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Demande extends StatefulWidget {
  const Demande({super.key});

  @override
  State<Demande> createState() => _DemandeState();
}

class _DemandeState extends State<Demande> {
 final CollectionReference _demande = FirebaseFirestore.instance.collection("demande");

  
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
    onPressed: (){},
    icon: const Icon(Icons.favorite_border_outlined),
    ),
    const SizedBox(width: 24),
     IconButton(
      onPressed: (){},
    icon: const Icon(Icons.chat),
    ),
     IconButton(onPressed: (){
     },
    icon: const Icon(Icons.person),
    ),

],
         ),
         ),
         )
      ),
   appBar: AppBar(
    
        title:  Text(
          "Liste des demandes",
          style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        backgroundColor:kPrimaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ), onPressed: () {  Navigator.push(context, 
            MaterialPageRoute(builder: (context)=>HomePage()));},
        ),actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.notifications_none,
                color: Colors.white,
              ),
              onPressed: () {}),
         
        ],
      
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Container(
                height: 500,
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
        ),
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
    MaterialPageRoute(builder: (context) => DonPage()),
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


     

