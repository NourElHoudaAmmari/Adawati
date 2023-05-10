import 'package:adawati/controllers/demande_controller.dart';
import 'package:adawati/helpers/constants.dart';
import 'package:adawati/models/demande_model.dart';
import 'package:adawati/screens/Profile/profile.dart';
import 'package:adawati/screens/demande/Add_Edit_demande.dart';
import 'package:adawati/screens/demande/EditDemandeScreen.dart';
import 'package:adawati/screens/demande/form_edit.dart';
import 'package:adawati/screens/dons/don.dart';
import 'package:adawati/screens/homepage/chat.dart';
import 'package:adawati/screens/homepage/chathome_page.dart';
import 'package:adawati/screens/homepage/favoirs.dart';
import 'package:adawati/screens/homepage/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
class DemandeScreen extends StatefulWidget {
  const DemandeScreen({super.key});

  @override
  State<DemandeScreen> createState() => _DemandeScreenState();
}

class _DemandeScreenState extends State<DemandeScreen> {
CollectionReference _demande = FirebaseFirestore.instance.collection("demande");
   final userId = FirebaseAuth.instance.currentUser!.uid;
   late Future<QuerySnapshot> demande;
   late Stream<QuerySnapshot> _stream;
   @override
  void get initState {
    super.initState;
     _stream = _demande.where('userId', isEqualTo: userId).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          _onButtomPressed();
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
    MaterialPageRoute(builder: (context) => ChatHomePage()),
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
   appBar: AppBar(
    
        title:  Text(
          "Liste des demandes",
          style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        backgroundColor:kontColor,
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
                       stream: _stream,
                         builder: (context, AsyncSnapshot  snapshots) {
                  if (snapshots.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: kontColor),
                    );
                  }
                     if (snapshots.data!.size == 0) {
            return Center(
              child: Text('Aucun élément enregistré dans la liste des demandes.'),
            );
          }
                  if (snapshots.hasData) {
                      List<QueryDocumentSnapshot> documents = snapshots.data.docs.where((doc) => doc['userId'] == userId).toList();
                               List<Map> items =
        documents.map((e) => e.data() as Map).toList();
                         
                    return ListView.builder(
                    itemCount: items.length,
                       itemBuilder: (context, index) {
                       final DocumentSnapshot records = snapshots.data!.docs[index];
                       return Padding(
                         padding: const EdgeInsets.symmetric(vertical: 10),
                         child: Slidable(
                           startActionPane: ActionPane(
                             motion: StretchMotion(),
                                children: [
                                  SlidableAction(
                                      onPressed: (context) async {
          // récupère la demande à modifier
          final DocumentSnapshot demande =
              snapshots.data!.docs[index];
          // ouvre l'écran de modification de demande
          final updatedDemande = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EditDemandeScreen(demande: demande),
            ),
          );
          // met à jour la demande
          if (updatedDemande != null) {
            await DemandeController()
                .update_demande(updatedDemande);
          }
        },
        icon: Icons.edit_note,
        backgroundColor: Colors.blue,
      ),
                                ],
                                     ),
                                     endActionPane: ActionPane(
                                      motion: StretchMotion(),
                                      children: [
                                        
                               SlidableAction(
  onPressed: (context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Supprimer la demande"),
          content: Text("Voulez-vous vraiment supprimer cette demande?"),
          actions: <Widget>[
            TextButton(
              child: Text('Non'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Oui' , style: TextStyle(color: Colors.red),),
              onPressed: () {
                DemandeController().delete_demande(DemandeModel(id: records.id));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  },
  icon: Icons.delete_outline,
  backgroundColor: Colors.red,
),

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