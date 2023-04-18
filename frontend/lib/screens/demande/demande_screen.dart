import 'package:adawati/controllers/demande_controller.dart';
import 'package:adawati/helpers/constants.dart';
import 'package:adawati/models/demande_model.dart';
import 'package:adawati/screens/Profile/profile.dart';
import 'package:adawati/screens/demande/Add_Edit_demande.dart';
import 'package:adawati/screens/demande/form_edit.dart';
import 'package:adawati/screens/homepage/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
class DemandeScreen extends StatefulWidget {
  const DemandeScreen({super.key});

  @override
  State<DemandeScreen> createState() => _DemandeScreenState();
}

class _DemandeScreenState extends State<DemandeScreen> {
 final CollectionReference _demande = FirebaseFirestore.instance.collection("demande");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed:(){
        },
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
          ), onPressed: () {  Navigator.of(context).pop();},
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
              SizedBox(height: 35,),
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
                           startActionPane: ActionPane(
                             motion: StretchMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context){
                                      final demande = DemandeModel(
                                        id:records.id,
                                        description: records["description"],
                                      );
                                       Navigator.push(context, 
                              MaterialPageRoute(
                                builder:((context)=>AddEditDemande(
                                  demande: demande,index: index,
                                ))));
                                         },
                                    icon: Icons.edit_note,
                                    backgroundColor: Colors.green,
                                    )
                                ],
                                     ),
                                     endActionPane: ActionPane(
                                      motion: StretchMotion(),
                                      children: [
                                        
                                  SlidableAction(
                                    onPressed: (context){
                                      DemandeController().delete_demande(DemandeModel(id: records.id));
                                    },
                                    icon: Icons.delete_outline,
                                    backgroundColor: Colors.red,
                                    )
                                      ]),
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
}