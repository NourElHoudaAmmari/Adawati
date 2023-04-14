
import 'package:adawati/helpers/constants.dart';
import 'package:adawati/screens/dons/add_don.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class DonList extends StatelessWidget {
   DonList({Key? key}) : super(key: key) {
    _stream = _reference.snapshots();
  }

  CollectionReference _reference =
  FirebaseFirestore.instance.collection('dons');
  late Stream<QuerySnapshot> _stream;

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Dons'),
      backgroundColor: kontColor,
      leading: IconButton(
          icon: Icon(
            Icons.notifications_none,
            color: Colors.white,
          ), onPressed: () {},
        ),
    ),
    body: StreamBuilder<QuerySnapshot>(
      stream: _stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //Check error
        if (snapshot.hasError) {
          return Center(child: Text('Some error occurred ${snapshot.error}'));
        }

        //Check if data arrived
        if (snapshot.hasData) {
          //get the data
          QuerySnapshot querySnapshot = snapshot.data;
          List<QueryDocumentSnapshot> documents = querySnapshot.docs;

          //Convert the documents to Maps
          List<Map> items = documents.map((e) => e.data() as Map).toList();

          //Display the grid
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //Number of columns
              childAspectRatio: 1, //Ratio of height to width of each grid item
            ),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              //Get the item at this index
              Map thisItem = items[index];
              //Return the widget for the grid item
              return Card(
                child: Column(
                  children: [
                    Expanded(
                      child: thisItem.containsKey('image')
                          ? Image.network('${thisItem['image']}')
                          : Placeholder(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${thisItem['title']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }

        //Show loader
        return Center(child: CircularProgressIndicator());
      },
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(context,
    MaterialPageRoute(builder: (context) => AddDon()),
  );
      },
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    ),
  );
}
}