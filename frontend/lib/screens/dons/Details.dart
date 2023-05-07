import 'package:adawati/providers/dons_provider.dart';
import 'package:adawati/screens/dons/don_list.dart';
import 'package:adawati/services/whishlist_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../helpers/constants.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../helpers/constants.dart';
import '../../services/whishlist_service.dart';
import 'editdon.dart';

class DonDetails extends StatefulWidget {
 DonDetails(this.itemId,{Key? key}) : super(key: key) {
  _reference = FirebaseFirestore.instance.collection('dons').doc(itemId);
  _futureData = _reference.get();
 }
   String itemId;
  late DocumentReference _reference;
  late Future<DocumentSnapshot> _futureData;

  @override
  State<DonDetails> createState() => _DonDetailsState();
}

class _DonDetailsState extends State<DonDetails> {
  late Map data;
  late String itemId;
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
         leading: IconButton(
            icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ), onPressed: () {       Navigator.push(context,
    MaterialPageRoute(builder: (context) => DonList()),
  );
            },
        ),actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.notifications_none,
                color: Colors.white,
              ),
              onPressed: () {}),
         
        ],
      ),    
      body:SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
        future: widget._futureData,
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
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                SizedBox(height: 10,),
                 Container(
                   height: 280.0,
                   width: 600.0,
                   decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                   padding: const EdgeInsets.all(5.0),
                   child: data.containsKey('image')
              ? Image.network('${data['image']}')
              : Container(),
                 ),
   
                 const SizedBox(height: 6),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text("Titre :  " 
                       '${data['title']}',
                       style: const TextStyle(
                         fontSize: 20,
                         fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,
                         color:kontColor,
                       ),
                       textAlign: TextAlign.left,
                     ),
                     IconButton(
      icon: Icon(Icons.edit),
      color: Colors.blue,
      onPressed: () {
            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditDon(data),
                              )
                              );
      },
      
    ),
                   ],
                   
                 ),
          
                          
                 SizedBox(height: 10),
                 const Text(
                   "Informations :",
                   style: TextStyle(
                     fontSize: 20,
                     fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,
                     color:Colors.black,
                   ),
                   textAlign: TextAlign.left,
                 ),
                 SizedBox(height: 8),
                     Row(
                       children: [
    Text(
      'Categorie : ',
      style: TextStyle(
        color: Colors.grey[800],
        fontSize: 18,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
    ),
    SizedBox(height: 6,),
    Text('${data['categorie']}',
      style: const TextStyle(
        fontSize: 16,
        color: Color.fromARGB(255, 118, 117, 117),
      ),
      textAlign: TextAlign.left,
    ),
  ],                   
                 ),
                     SizedBox(height: 10,),
                     
  Row(
  //crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Etat : ',
      style: TextStyle(
        color: Colors.grey[800],
        fontSize: 18,
        fontStyle: FontStyle.italic,
         fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.right,
    ),
    SizedBox(height: 6,),
                 Text(
                   ' ${data['etat']}',
                   style: const TextStyle(
                     fontSize: 16,
                    fontStyle: FontStyle.normal,
                     color:Color.fromARGB(255, 118, 117, 117),
                   ),
                   textAlign: TextAlign.right,
                 ),
                 ],
                ),
                SizedBox(height: 10,),
                Row(
  //crossAxisAlignment: CrossAxisAlignment.start,
  children: [
     Text(
      'Adresse :',
      style: TextStyle(
        color: Colors.grey[800],
        fontSize: 18,
        fontStyle: FontStyle.italic,
         fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.left,
    ),
     SizedBox(height: 6,),
    //Icon(Icons.place, color: Colors.grey),
     SizedBox(width: 8),
    Text(
      '${data['adresse']}',
      style: const TextStyle(
        fontSize: 16,
        color: Color.fromARGB(255, 118, 117, 117),
      ),
      textAlign: TextAlign.left,
    ),
 
                 ],
                ),
                SizedBox(height: 10,),
               
             
    
                Divider(thickness: 2,),
                           Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
     Text(
      'Description',
      style: TextStyle(
        color: Colors.grey[800],
        fontSize: 20,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold
      ),
      textAlign: TextAlign.left,
    ),
     SizedBox(height: 6,),
                
                   Text(
                   '${data['description']}',
                   style: const TextStyle(
                     fontSize: 16,
                     color: Color.fromARGB(255, 118, 117, 117),
                   ),
                   textAlign: TextAlign.left,
                 ),
  ],
                         ),
                         SizedBox(height: 12,),
  

               ],
             ),
           ),
           );

          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      ),
    );
  }
  
}