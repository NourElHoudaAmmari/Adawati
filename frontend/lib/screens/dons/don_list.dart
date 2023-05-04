
import 'package:adawati/helpers/constants.dart';
import 'package:adawati/screens/Profile/profile.dart';
import 'package:adawati/screens/demande/Add_Edit_demande.dart';
import 'package:adawati/screens/dons/don.dart';
import 'package:adawati/screens/dons/don_details.dart';
import 'package:adawati/screens/homepage/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DonList extends StatefulWidget {
    final User? user; 
  DonList({Key? key, this.user}) : super(key: key) ;
  @override
  State<DonList> createState() => _DonListState();
}

class _DonListState extends State<DonList> {
  final db = FirebaseFirestore.instance;
  late String id;
   String?  donID;
  late Stream<QuerySnapshot> _stream;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference _reference = FirebaseFirestore.instance.collection('dons');
  late Future<QuerySnapshot> donations;

  @override
  void get initState{
    super.initState;
     
   _stream = _reference.where('userId', isEqualTo: userId).snapshots();
  }
void _deleteDonation(String id) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr(e) de vouloir supprimer ce don ?'),
        actions: <Widget>[
          TextButton(
            child: Text('Annuler'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Supprimer'),
            onPressed: () async {
              try {
                await _reference.doc(id).delete();
                Navigator.of(context).pop();
                // Show a success message
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Suppression réussie'),
                      content: Text('Le don a été supprimé avec succès.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              } catch (e) {
                Navigator.of(context).pop();
                // Show an error message
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Echec de supprimer ce don'),
                      content: Text('Une erreur s\'est produite lors de la suppression de ce don: $e'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ],
      );
    },
  );
}


final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
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
        title: Text('Liste des dons'),
        elevation: 0.0,
        backgroundColor: kontColor,
         leading: IconButton(
            icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ), onPressed: () {    Navigator.of(context).pop();
            },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //Check error
          if (snapshot.hasError) {
            return Center(
                child: Text('Some error occurred ${snapshot.error}'));
          }

          //Check if data arrived
          if (snapshot.hasData) {
            //get the data
            QuerySnapshot querySnapshot = snapshot.data!;
           // List<QueryDocumentSnapshot> documents = querySnapshot.docs;
            List<QueryDocumentSnapshot> documents = snapshot.data.docs.where((doc) => doc['userId'] == userId).toList();

            //Convert the documents to Maps
   List<Map> items = documents.map((e) => {
                    'id':e.id,
                    'title':e['title'],
                     'image':e['image'],
                      'description':e['description'],
                     'adresse':e['adresse'],
                      'createdAt':e['createdAt'],
                  }).toList();


            //Display the grid
           return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //two columns
          mainAxisSpacing: 0.1, //space the card
          childAspectRatio: 0.800, //space largo de cada card
        ),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          //Get the item at this index
          Map thisItem = items[index];
          //Return the widget for the grid item
          return Card(
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () {Navigator.push(
                        context,
                       MaterialPageRoute(
                       builder: (context) =>DonDetails(thisItem['id'])
                       ),
                        );
                       // Naviguer vers la page souhaitée
                            },
                  child: Container(
                    child: thisItem.containsKey('image')
                        ? Image.network('${thisItem['image']}')
                        : Placeholder(),
                    width: 170,
                    height: 120,
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      '${thisItem['title']}',
                      style: TextStyle(
                        color: kontColor,
                        fontSize: 19.0,
                      ),
                    ),
                    subtitle: Text(
                      '${thisItem['description']}',
                       maxLines: 1,
      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                   onTap: () {Navigator.push(
                        context,
                       MaterialPageRoute(
                       builder: (context) =>DonDetails(thisItem['id'])),
                        );
                       // Naviguer vers la page souhaitée
                            },
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                            _deleteDonation(thisItem['id']);
                      
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }

    // Show loader if data is not yet available
    return Center(child: CircularProgressIndicator());
  },
),
/*floatingActionButton: FloatingActionButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DonPage()),
    );
  },
  tooltip: 'Add',
  child: const Icon(Icons.add),
),*/
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