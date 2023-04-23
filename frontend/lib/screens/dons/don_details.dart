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

class DonDetails extends StatefulWidget {
 DonDetails(this.itemId,{Key? key}) : super(key: key) {
  _reference = FirebaseFirestore.instance.collection('dons').doc(itemId);
  _futureData = _reference.get();

      WhishListService _service = WhishListService();
 }
   String? itemId;
   
  late DocumentReference _reference;
  late Future<DocumentSnapshot> _futureData;

  @override
  State<DonDetails> createState() => _DonDetailsState();
}

class _DonDetailsState extends State<DonDetails> {
  late WhishListService _service;
   List fav = [];
bool _isLiked = false;
  late Map data;

 @override
 void get initState{
   super.initState;
    _service = WhishListService();
  getFavourites();
 
 }

  getFavourites(){
     _service.dons.doc(widget._reference.id).get().then((value){
      if(mounted){
setState(() {
  fav = value['favourites'];  
});
      }
if(fav.contains(_service.user!.uid)){
  if(mounted){
  setState(() {
    _isLiked =true;
  });
  }
}else{
  if(mounted){
  setState(() {
    _isLiked=false;
  });
  }
}

     });
  }

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
      body:SingleChildScrollView(
        child: 
     
       FutureBuilder<DocumentSnapshot>(
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
                   height: 280.0,

                   width: 600.0,
                   decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                   padding: const EdgeInsets.all(5.0),
                   child: data.containsKey('image')
              ? Image.network('${data['image']}')
              : Container(),
                 ),
   
                 const SizedBox(height: 6),
                 Text("Titre :  " 
                   '${data['title']}',
                   style: const TextStyle(
                     fontSize: 20,
                     fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,
                     color:kontColor,
                   ),
                   textAlign: TextAlign.left,
                 ),
                 SizedBox(height: 3,),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(
      "Publié le : ${DateFormat('dd-MM-yyyy HH:mm').format(data['createdAt'].toDate())}",
      style: const TextStyle(
        fontSize: 14,
        fontStyle: FontStyle.normal,
        color: Color.fromARGB(255, 92, 92, 92),
      ),
      textAlign: TextAlign.left,
    ),
    IconButton(
      icon: Icon(_isLiked? Icons.favorite : Icons.favorite_border),
      color: _isLiked ? Colors.red : Colors.black,
      onPressed: () {
         
        setState(() {
          _isLiked = !_isLiked;
        });
    WhishListService().updateFavourite(context, _isLiked, widget.itemId);
    print(widget.itemId);
       

        
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
                     Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Categorie',
      style: TextStyle(
        color: Colors.grey[800],
        fontSize: 18,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
    ),
    SizedBox(height: 6,),
  
                Row(
  children: [
    Icon(Icons.category, color: kPrimaryColor),
     SizedBox(width: 8),
    Text(
      '${data['categorie']}',
      style: const TextStyle(
        fontSize: 16,
        color: Color.fromARGB(255, 118, 117, 117),
      ),
      textAlign: TextAlign.left,
    ),
  ],
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
         fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.right,
    ),
    SizedBox(height: 6,),
                 Text(
                   '${data['etat']}',
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
                Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
     Text(
      'Adresse',
      style: TextStyle(
        color: Colors.grey[800],
        fontSize: 18,
        fontStyle: FontStyle.italic,
         fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.left,
    ),
     SizedBox(height: 6,),
                 Row(
  children: [
    Icon(Icons.place, color: Colors.grey),
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
                                       Container(
                  decoration: BoxDecoration(border:Border.all(color: Colors.white),borderRadius: BorderRadius.circular(8)  ),
     
      child: new Row(
       // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(width: 49,),
        InkWell(
  onTap: ()async {
final Uri url=Uri(scheme: 'tel',
path:'${data['phone']}' );
if(await canLaunchUrl(url)){
  await launchUrl(url);
}else{
  print('cannot launch this url');
}
  },
  child: IconoMenu(
    icon: Icons.call,
    label: "Appel",
  ),
),
SizedBox(width:180,),

        InkWell(
  onTap: () {
    // Ajoutez ici la logique qui doit être exécutée lors du clic sur l'icône
  },
  child: IconoMenu(
    icon: Icons.message,
    label: "Message",
  ),
),
        ],
      ),
      
    ),
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
/*class IniciarIcon extends StatelessWidget {
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
}*/
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