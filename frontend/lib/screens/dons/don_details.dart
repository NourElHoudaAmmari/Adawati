import 'package:adawati/screens/dons/don_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../../helpers/constants.dart';

class DonDetails extends StatefulWidget {
 DonDetails(this.itemId,{Key? key}) : super(key: key) {
  _reference = FirebaseFirestore.instance.collection('dons').doc(itemId);
  _futureData = _reference.get();
    
 }
   String? itemId;
  late DocumentReference _reference;
  late Future<DocumentSnapshot> _futureData;

  @override
  State<DonDetails> createState() => _DonDetailsState();
}

class _DonDetailsState extends State<DonDetails> {
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
         leading: IconButton(
            icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ), onPressed: () {    Navigator.of(context).pop();
            },
        ),actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.notifications_none,
                color: Colors.white,
              ),
              onPressed: () {}),
         
        ],
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
             //alignment: Alignment.topLeft,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 const SizedBox(height: 10),
                 Container(
                   height: 270.0,
                   width: 600.0,
                   decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                   padding: const EdgeInsets.all(5.0),
                   child: data.containsKey('image')
              ? Image.network('${data['image']}')
              : Container(),
                 ),
                 new IniciarIcon(),
                 const SizedBox(height: 10),
                 Text("Titre :  " 
                   '${data['title']}',
                   style: const TextStyle(
                     fontSize: 20,
                     fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,
                     color:kontColor,
                   ),
                   textAlign: TextAlign.left,
                 ),
                 SizedBox(height: 13),
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
                     Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Categorie',
      style: TextStyle(
        color: Colors.grey[800],
        fontSize: 18,
        fontStyle: FontStyle.italic,
      ),
    ),
    SizedBox(height: 6,),
                 Text( 
                   '${data['categorie']}',
                   style: const TextStyle(
                     fontSize: 16,
                     color: Colors.grey,
                   ),
                   textAlign: TextAlign.left,
                 ),
  ],
                     ),
                     SizedBox(height: 10,),
  Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Etat',
      style: TextStyle(
        color: Colors.grey[800],
        fontSize: 18,
        fontStyle: FontStyle.italic,
      ),
      textAlign: TextAlign.right,
    ),
    SizedBox(height: 6,),
                 Text(
                   '${data['etat']}',
                   style: const TextStyle(
                     fontSize: 16,
                    fontStyle: FontStyle.normal,
                     color: Colors.grey,
                   ),
                   textAlign: TextAlign.right,
                 ),
                 ],
                ),
                SizedBox(height: 10,),
                Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
     Text(
      'Adresse',
      style: TextStyle(
        color: Colors.grey[800],
        fontSize: 18,
        fontStyle: FontStyle.italic,
      ),
      textAlign: TextAlign.left,
    ),
     SizedBox(height: 6,),
                 Text(
                   '${data['adresse']}',
                   style: const TextStyle(
                     fontSize: 16,
                     color: Colors.grey,
                   ),
                   textAlign: TextAlign.left,
                 ),
                 ],
                ),
                Divider(thickness: 2,),
                         Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
     Text(
      'Description',
      style: TextStyle(
        color: Colors.grey[800],
        fontSize: 18,
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
                     color: Colors.grey,
                   ),
                   textAlign: TextAlign.left,
                 ),
  ],
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
class IniciarIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.all(10.0),
      child: new Row(
        children: <Widget>[
          new IconoMenu(
            icon: Icons.call,
            label: "Appel",
          ),
          new IconoMenu(
            icon: Icons.message,
            label: "Message",
          ),
        ],
      ),
      
    );
  }
}
class IconoMenu extends StatelessWidget {
  IconoMenu({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: new Column(
        children: <Widget>[
          new Icon(
            icon,
            size: 38.0,
            color: kPrimaryColor,
          ),
          new Text(
            label,
            style: new TextStyle(fontSize: 12.0, color: Color.fromARGB(255, 222, 62, 14)),
          )
        ],
      ),
    );
  }
}