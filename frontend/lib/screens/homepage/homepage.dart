// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sort_child_properties_last, avoid_returning_null_for_void, must_be_immutable, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables
import 'package:adawati/helpers/constants.dart';
import 'package:adawati/screens/homepage/chathome_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adawati/screens/Profile/profile.dart';
import 'package:adawati/screens/demande/Add_Edit_demande.dart';
import 'package:adawati/screens/dons/don.dart';
import 'package:adawati/screens/dons/don_details.dart';
import 'package:adawati/screens/homepage/chat.dart';
import 'package:adawati/screens/homepage/favoirs.dart';
import 'package:adawati/screens/main_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/userModel.dart';
import '../demande/demande.dart';

//import '../dons/don_details.dart';

class HomePage extends StatefulWidget {
    HomePage({Key? key}) : super(key: key) ;
  @override
  State<HomePage> createState() => _HomePageState();
}
Future<void> _refresh(){
  return Future.delayed(Duration(seconds: 2));
}

class _HomePageState extends State<HomePage> {
   TextEditingController _searchController = TextEditingController();
  
  final db = FirebaseFirestore.instance;
  late String id;
  late Stream<QuerySnapshot> _stream;
  CollectionReference _reference = FirebaseFirestore.instance.collection('dons');
    List<String> docIDs = [];
  bool _isSearching = false; // Added flag to track searching status
  late String _searchCategory = ''; // Added variable to store search category
  late String _searchTitle = '';
  bool _isBlocked = false;
  @override
void initState(){
  super.initState;
    //Create stream to listen to the 'items' collection
    _stream = _reference.snapshots();
    
    _stream = _reference.orderBy('createdAt', descending: true).snapshots();
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
   // controller: _searchController,
    onChanged: (value) {
      setState(() {
        _stream = _reference
        .where('categorie', isEqualTo: value)
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
                     'adresse':e['adresse'],
                      'createdAt':e['createdAt'],
                  }).toList();
  
                  //Display the grid
                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: GridView.builder(
                      padding: EdgeInsets.all(8),
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
                             crossAxisAlignment: CrossAxisAlignment.start,
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
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: kontColor
                                  ),
                                ),
                              ),
                              Divider(thickness: 1,),
                              Column(
                                children: [
                  
                              
                         Row(
                    children: [
                      Icon(Icons.place_outlined, color: Colors.grey.shade500,),
                      SizedBox(width: 5), // Espacement entre l'icône et le texte
                      Text(
                        '${thisItem['adresse']}',
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
                  const SizedBox(height: 5.0,),
                     Row(
                    children: [
                      Icon(Icons.alarm, color: Colors.grey.shade500),
                      SizedBox(width: 5), // Espacement entre l'icône et le texte
                     Text(
                    '${DateFormat('dd-MM-yyyy').format(thisItem['createdAt'].toDate())}',
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
                        ),
                        );
                      },
                    ),
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


     

