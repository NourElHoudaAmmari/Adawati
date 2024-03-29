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
import 'package:adawati/screens/homepage/notif_page.dart';
import 'package:adawati/screens/main_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../homepage/favoirs.dart';

class Demande extends StatefulWidget {
  const Demande({super.key});

  @override
  State<Demande> createState() => _DemandeState();
}
Future<void> _refresh(){
  return Future.delayed(Duration(seconds: 2));
}
class _DemandeState extends State<Demande> {
  late Stream<QuerySnapshot> _stream;
 final CollectionReference _demande = FirebaseFirestore.instance.collection("demande");
  bool _isBlocked = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  void initState(){
     super.initState;
    _stream = _demande.orderBy('createdAt', descending: true).snapshots();
      fetchBlockedStatus();
  }
   Future<void> fetchBlockedStatus() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userSnapshot.exists) {
        setState(() {
          _isBlocked = userSnapshot.get('isBlocked') ?? false;
        });
      }
    }
  }
  void searchRequests(String query) {
  FirebaseFirestore.instance
    .collection('demandes')
    .where('description', isEqualTo: query)
    .get()
    .then((QuerySnapshot snapshot) {
      // Traitez les résultats de la recherche ici
      // Mettez à jour votre état de widget avec les résultats obtenus
    })
    .catchError((error) {
      // Gérez les erreurs de recherche ici
    });
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
         if (_isBlocked) {
      final snackBar = SnackBar(
  content: Text(
  "cet utilisateur a été désactivé, veuillez contacter le support pour obtenir de l'aide",
    style: TextStyle(color: Colors.white),
  ),
  backgroundColor: Colors.red, // Définir la couleur d'arrière-plan comme rouge
);
ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }else{
         Navigator.push(context,
    MaterialPageRoute(builder: (context) => Favoirs()),
      );
    }
    },
    icon: const Icon(Icons.favorite_border_outlined),
    ),
    const SizedBox(width: 24),
     IconButton(
      onPressed: (){
           if (_isBlocked) {
      final snackBar = SnackBar(
  content: Text(
  "cet utilisateur a été désactivé, veuillez contacter le support pour obtenir de l'aide",
    style: TextStyle(color: Colors.white),
  ),
  backgroundColor: Colors.red, // Définir la couleur d'arrière-plan comme rouge
);
ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }else{
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => ChatHomePage()),
  );
    }
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
              onPressed: () {
                              Navigator.push(context,
    MaterialPageRoute(builder: (context) => NotificationScreen()),
      );
              }),
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
   /* onChanged: (value) {
      setState(() {
        _stream = _demande
        .where('description', isEqualTo: value)
        .snapshots();
       //_stream = _reference.where('title', isEqualTo: value).snapshots();
      });
    },*/
    decoration: InputDecoration(
      hintText: 'Rechercher',
      prefixIcon: Icon(Icons.search),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      
    ),
    cursorColor: Colors.grey,
     onChanged: (query) {
    searchRequests(query); 
  },
    
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
                    return RefreshIndicator(
                       onRefresh: _refresh,
                      child: ListView.builder(
                      itemCount: snapshots.data!.docs.length,
                         itemBuilder: (context, index) {
                         final DocumentSnapshot records = snapshots.data!.docs[index];
                         return Padding(
                           padding: const EdgeInsets.all(8),
                           child: Slidable(
                                  child: SizedBox(
                                     height: 110, 
                                     child: Card(
                      child: ListTile(
                        tileColor: Colors.lightBlue[50],
                        title: Text(records["description"]),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8), // Ajouter un espacement de 8 pixels
                            Text(records["userName"]),
                            const SizedBox(height: 4), // Ajouter un espacement de 4 pixels
                            Text(records["userEmail"]),
                          ],
                        ),
                        trailing: Text(
                          DateFormat('dd-MM-yyyy').format(records['createdAt'].toDate()),
                          style: TextStyle(color: Colors.deepOrange[800]),
                        ),
                      ),
                    ),
                                   ),
                                      
                                      
                                        ),
                         );
                                        },
                                                ),
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
    if (_isBlocked) {
      // Show a message or perform an action to notify the user that they are blocked.
      // For example, show a snackbar with an error message.
      final snackBar = SnackBar(
  content: Text(
    'Vous ne pouvez pas ajouter de dons ou de demandes.',
    style: TextStyle(color: Colors.white),
  ),
  backgroundColor: Colors.red, // Définir la couleur d'arrière-plan comme rouge
);
ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
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


     

