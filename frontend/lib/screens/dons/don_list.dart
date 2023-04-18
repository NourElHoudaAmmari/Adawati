
import 'package:adawati/helpers/constants.dart';
import 'package:adawati/screens/dons/don.dart';
import 'package:adawati/screens/dons/don_details.dart';
import 'package:adawati/screens/homepage/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';

class DonList extends StatefulWidget {
  DonList({Key? key}) : super(key: key) ;
    
  


  @override
  State<DonList> createState() => _DonListState();
}

class _DonListState extends State<DonList> {
  final db = FirebaseFirestore.instance;
  late String id;
  late Stream<QuerySnapshot> _stream;
  CollectionReference _reference = FirebaseFirestore.instance.collection('dons');

  @override
  void initState(){
    super.initState();
       _stream = _reference.snapshots();
  }
  void deleteData(DocumentSnapshot doc)async{
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des dons'),
        elevation: 0.0,
        backgroundColor: kontColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
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
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;

            //Convert the documents to Maps
            List<Map> items =
                documents.map((e) => e.data() as Map).toList();

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
                       builder: (context) =>DonDetails(thisItem['id'])),
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
                      style: TextStyle(
                        color: Colors.grey,
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
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {},
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
floatingActionButton: FloatingActionButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DonPage()),
    );
  },
  tooltip: 'Add',
  child: const Icon(Icons.add),
),
);
}
}