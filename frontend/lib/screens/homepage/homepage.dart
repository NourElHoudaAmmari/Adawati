// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sort_child_properties_last, avoid_returning_null_for_void, must_be_immutable, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables
import 'package:adawati/helpers/constants.dart';
import 'package:adawati/repository/authentification_repository.dart';
import 'package:adawati/screens/Login/login_screen.dart';
import 'package:adawati/screens/Profile/profile.dart';
import 'package:adawati/screens/demande/Add_Edit_demande.dart';
import 'package:adawati/screens/dons/don.dart';
import 'package:adawati/screens/dons/don_details.dart';
import 'package:adawati/screens/main_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//import '../dons/don_details.dart';

class HomePage extends StatefulWidget {
    HomePage({Key? key}) : super(key: key) ;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   TextEditingController _searchController = TextEditingController();
  
  final db = FirebaseFirestore.instance;
  late String id;
  late Stream<QuerySnapshot> _stream;
  CollectionReference _reference = FirebaseFirestore.instance.collection('dons');
  @override
  void get  initState {
    super.initState;
    //Create stream to listen to the 'items' collection
    _stream = _reference.snapshots();
   

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
 TextEditingController _searchController = TextEditingController();
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
        ],
      ),

      body: Column(
        children: [
           Padding(
  padding: const EdgeInsets.all(8.0),
  child: Row(
    children: [
      Expanded(
        child: TextField(
          controller: _searchController, // Utiliser le TextEditingController
 onChanged: (value) {
  // Filtrer les données du flux en fonction du texte de recherche
  setState(() {
    _stream = _reference.where('title', isGreaterThanOrEqualTo: value).snapshots();
  });
},
          decoration: InputDecoration(
            hintText: 'Rechercher',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.filter_list,
        color: Colors.red,),
      ),
    ],
  ),
),

          
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                //Check error
                if (snapshot.hasError) {
                  return Center(child: Text('Some error occurred ${snapshot.error}'));
                }
          
                //Check if data arrived
                if (snapshot.hasData) {
                  //get the data
                  QuerySnapshot querySnapshot = snapshot.data!;
                  List<QueryDocumentSnapshot> documents = querySnapshot.docs;
          
                  //Convert the documents to Maps
                  List<Map> items = documents.map((e) => {
                    'id':e.id,
                    'title':e['title'],
                     'image':e['image'],
                     'description':e['description'],
                  }).toList();
          
                  //Display the grid
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, //Number of columns
                      childAspectRatio: 0.7, //Ratio of height to width of each grid item
                    ),
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      //Get the item at this index
                      Map thisItem = items[index];
                      //Return the widget for the grid item
                      return Card(
                        child: GestureDetector(
                       onTap: () {Navigator.push(
                        context,
                       MaterialPageRoute(
                       builder: (context) =>DonDetails(thisItem['id'])),
                        );
                       // Naviguer vers la page souhaitée
                            },
                        child: Column(
                          children: [
                            Expanded(
                              child: thisItem.containsKey('image')
                                  ? Image.network('${thisItem['image']}')
                                  :  Container(),
                                
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${thisItem['title']}',
                               
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: kontColor
                                ),
                              ),
                            ),
                            Divider(thickness: 1,),
                             Text('${thisItem['description']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                color: Colors.grey.shade500,
                                  fontStyle: FontStyle.italic
                                ),
                              ),
                            const SizedBox(height: 5.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: (){}, 
                                  icon: Icon(CupertinoIcons.heart),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      );
                    },
                  );
                }
          
                //Show loader
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
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


     

