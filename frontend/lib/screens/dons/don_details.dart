import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../../helpers/constants.dart';

class DonDetails extends StatelessWidget {
 DonDetails(this.itemId,{Key? key}) : super(key: key) {
  _reference = FirebaseFirestore.instance.collection('dons').doc(itemId);
  _futureData = _reference.get();
    
 }
   String? itemId;
  late DocumentReference _reference;
  late Future<DocumentSnapshot> _futureData;
  late Map data;
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text(
           "Details",
          style: TextStyle(color: Colors.white, fontSize: 22,fontWeight: FontWeight.bold),
        ),
        
        elevation: 0.0,
        backgroundColor: kontColor,
       // actions: [
        //  IconButton(
              //onPressed: () {
                //add the id to the map
               // data['id'] = itemId;
             // },
              //icon: Icon(Icons.edit)),
          //IconButton(onPressed: (){
            //Delete the item
            //_reference.delete();
         // }, icon: Icon(Icons.delete))
       // ],
      ),    //,
      body: FutureBuilder<DocumentSnapshot>(
        future: _futureData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Some error occurred ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            //Get the data
            DocumentSnapshot documentSnapshot = snapshot.data;
            data = documentSnapshot.data() as Map;

            //display the data
           return Padding(
             padding: const EdgeInsets.only(left: 20.0),
             child: Align(
             //alignment: Alignment.topLeft,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 const SizedBox(height: 10),
                 Container(
                   height: 270,
                   width: 550,
                   decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                   padding: const EdgeInsets.all(5.0),
                   child: data.containsKey('image')
              ? Image.network('${data['image']}')
              : Container(),
                 ),
                 const SizedBox(height: 10),
                 Text("Titre :  " 
                   '${data['title']}',
                   style: const TextStyle(
                     fontSize: 27,
                     fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,
                     color:kontColor,
                   ),
                   textAlign: TextAlign.left,
                 ),
                 SizedBox(height: 10),
                 const Text(
                   "Informations :",
                   style: TextStyle(
                     fontSize: 26,
                     fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,
                     color:Colors.black,
                   ),
                   textAlign: TextAlign.left,
                 ),
                 SizedBox(height: 8),
                 Text(
                   "Categorie : \n " 
                   '${data['categorie']}',
                   style: const TextStyle(
                     fontSize: 24,
                     color: Colors.black,
                   ),
                   textAlign: TextAlign.left,
                 ),
                 Text("Etat : \n  " 
                   '${data['etat']}',
                   style: const TextStyle(
                     fontSize: 24,
                    fontStyle: FontStyle.normal,
                     color: Colors.black,
                   ),
                   textAlign: TextAlign.left,
                 ),
                 Text("Adresse : \n  "
                   '${data['adresse']}',
                   style: const TextStyle(
                     fontSize: 24,
                     color: Colors.black,
                   ),
                   textAlign: TextAlign.left,
                 ),
                   Text("Description : \n  "
                   '${data['description']}',
                   style: const TextStyle(
                     fontSize: 24,
                     color: Colors.black,
                   ),
                   textAlign: TextAlign.left,
                 ),
               ],
             ),
           ),
           );

          }


          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}