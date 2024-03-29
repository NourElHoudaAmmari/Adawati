import 'package:adawati/screens/Profile/profile.dart';
import 'package:adawati/screens/demande/Add_Edit_demande.dart';
import 'package:adawati/screens/dons/don.dart';
import 'package:adawati/screens/dons/don_details.dart';
import 'package:adawati/screens/homepage/chathome_page.dart';
import 'package:adawati/screens/homepage/homepage.dart';
import 'package:adawati/screens/homepage/notif_page.dart';
import 'package:adawati/services/whishlist_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../helpers/constants.dart';

class Favoirs extends StatefulWidget {
  const Favoirs({super.key});

  @override
  State<Favoirs> createState() => _FavoirsState();
}

class _FavoirsState extends State<Favoirs> {
    bool _isBlocked = false;
    late WhishListService _service;
     @override
 void  initState(){
  super.initState;
    _service = WhishListService();
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
   appBar: AppBar(
    
        title:  Text(
          "Mes favoirs",
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
              onPressed: () {
                              Navigator.push(context,
    MaterialPageRoute(builder: (context) => NotificationScreen()),
      );
              }),
         
        ],
      
      ),
      
     body: StreamBuilder<QuerySnapshot>(
        stream: _service.dons.where('favourites',arrayContains: _service.user!.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Une erreur est survenue.');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.size == 0) {
            return Center(
              child: Text('Aucun élément enregistré dans les favoris.'),
            );
          }
          SizedBox(height: 35);
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 0.1,
              childAspectRatio: 0.800,
            ),
            itemCount: snapshot.data!.size,
            itemBuilder: (BuildContext context, int index) {
              var data = snapshot.data!.docs[index];
              return Card(
  child: Column(
    children: <Widget>[
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DonDetails(data['id'])),
          );
        },
        child: Image.network(
          data['image'],
          width: double.infinity,
          height: 150,
          fit: BoxFit.cover,
        ),
      ),
      Expanded(
        child: ListTile(
          title: Text(
            data['title'],
            style: TextStyle(
              color: kontColor,
              fontSize: 19.0,
            ),
          ),
        
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DonDetails(data['id'])),
            );
          },
        ),
      ),
      Divider(
        thickness: 1,
      ),
      Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.place_outlined,
                color: Colors.grey.shade500,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                data['adresse'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey.shade500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 3.0,
          ),
          Row(
            children: [
              Icon(Icons.alarm, color: Colors.grey.shade500),
              SizedBox(
                width: 5,
              ),
              Text(
                DateFormat('dd-MM-yyyy').format(data['createdAt'].toDate()),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey.shade500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  ),
);

            },
          );
        },
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