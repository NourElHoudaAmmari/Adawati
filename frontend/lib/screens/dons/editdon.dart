import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../helpers/constants.dart';
import 'Details.dart';

class EditDon extends StatefulWidget {
  Map data;
  EditDon(this.data, {Key? key}) : super(key: key);
  @override
  _EditDonState createState() => _EditDonState();
}

class _EditDonState extends State<EditDon> {
  late Map data;
 String _imageURL = '';
  Uint8List? _imageBytes;
  late DocumentReference _reference;
  late TextEditingController _imageController;
  late TextEditingController _titleController;
  late TextEditingController _categorieController;
  late TextEditingController _etatController;
  late TextEditingController _descriptionController;
  late TextEditingController _adresseController;
  late TextEditingController _phoneController;
  GlobalKey<FormState> _key = GlobalKey();
  String  selectedCategorie="";
  String selectedEtat = "";

  @override
  void  initState() {
    
    super.initState;
    data = widget.data;
    _imageURL = data['image'];
    selectedCategorie= widget.data['categorie'];
    selectedEtat = widget.data['etat'];
    _imageController = TextEditingController(text: widget.data['image']);
    _titleController = TextEditingController(text: widget.data['title']);
    _categorieController = TextEditingController(text: widget.data['categorie']);
    _etatController = TextEditingController(text: widget.data['etat']);
    _descriptionController = TextEditingController(text: widget.data['description']);
    _adresseController = TextEditingController(text: widget.data['adresse']);
     _phoneController = TextEditingController(text: widget.data['phone']);
    _reference = FirebaseFirestore.instance.collection('dons').doc(widget.data['id']);
  }

  @override
  void dispose() {
    _imageController.dispose();
    _titleController.dispose();
    _categorieController.dispose();
    _etatController.dispose();
    _descriptionController.dispose();
    _adresseController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

void _updateImage() async {
  final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    File file = File(pickedFile.path);
    String imageURL = await uploadImageToFirebaseStorage(file);
    setState(() {
      _imageURL = imageURL;
    });
    _reference.update({'image': imageURL});
  }
}

Future<String> uploadImageToFirebaseStorage(File file) async {
  final Reference reference = FirebaseStorage.instance.ref().child('don_images').child(file.path.split('/').last);
  final UploadTask uploadTask = reference.putFile(file);
  final TaskSnapshot snapshot = await uploadTask;
  String imageURL = await snapshot.ref.getDownloadURL();
  return imageURL;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kontColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Modifier Don',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _key,
            child: Column(
              children: [
                 InkWell(
        onTap: _updateImage,
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
        border: Border.all(),
          ),
          child: _imageURL.isEmpty
          ? Center(
              child: Text('Ajouter image'),
            )
          : Image.network(
              _imageURL,
              fit: BoxFit.cover,
            ),
        ),
      ),  
      SizedBox(height: 8),                
                Container(
                  width: 300,
                  child: TextFormField(
                    controller:   _titleController,
                    decoration:
                        InputDecoration(hintText: 'Titre'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return '***champ obligatoire';
                      }
                
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 8),                
                Container(
                  width: 300,
                  child: TextFormField(
                    controller:_descriptionController,
                    decoration:
                        InputDecoration(hintText: 'Description'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return '***champ obligatoire';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: 300,
                  child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('categories').snapshots(),
                  builder: (context, snapshot) {
                    List<DropdownMenuItem<String>> categorieItems = [];
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    } else {
                      final categories = snapshot.data?.docs.reversed.toList();
                      categorieItems.add(
                        const DropdownMenuItem(
                          value: "0",
                          child: Text('Categorie sélectionnée'),
                        ),
                      );
                      for (var category in categories!) {
                        categorieItems.add(DropdownMenuItem(
                          value: category["name"],
                          child: Text(
                            category['name'],
                          ),
                        ));
                      }
                    }
                    return DropdownButton(
                      items: categorieItems,
                      onChanged: (categorieValue) {
                        setState(() {
                          selectedCategorie = categorieValue as String;
                        });
                        print(categorieValue);
                      },
                      value: selectedCategorie,
                      isExpanded: false,
                    );
                  }
                ),
                ),
      
              
                SizedBox(height: 8),
             Container(
             width: 300,
               child: StreamBuilder<QuerySnapshot>(
               stream: FirebaseFirestore.instance.collection('etats').snapshots(),
               builder: (context,snapshot){
                 List<DropdownMenuItem>etatItems=[];
                 if(!snapshot.hasData){
                   return const CircularProgressIndicator();
                 }else{
                   final etats = snapshot.data?.docs.reversed.toList();
                   etatItems.add(
                     const DropdownMenuItem(
                       value: "0",
                       child: Text('Etat sélectionné'),
                     ),
                   );
                   for(var etat in etats!){
                     etatItems.add(DropdownMenuItem(
                       value: etat["libelle"],
                       child: Text(
                etat['libelle'],
                       ),
                     ));
                   }
                 }
                 return DropdownButton(
                   items: etatItems,
                   onChanged: (etatValue) {
                     setState(() {
                       selectedEtat = etatValue as String;
                     });
                     print(etatValue);
                   },
                   value: selectedEtat,
                   isExpanded: false,
                 );
               }
             ),
             ),
      
                SizedBox(height: 8),
                Container(
                  width: 300,
                  child: TextFormField(
                   controller: _adresseController,
                    decoration:
                       InputDecoration(hintText: 'Adresse '),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return '***champ obligatoire';
                      }
                
                      return null;
                    },
                             ),
                ),
                
                SizedBox(height: 8),
                Container(
                  width: 300,
                  child: TextFormField(
                   controller:_phoneController,
                    decoration:
                       InputDecoration(hintText: 'Numéro de téléphone '),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return '***champ obligatoire';
                      }
                
                      return null;
                    },
                             ),
                ),
                SizedBox(height: 12),
                Center(
                  child:SizedBox(
                    width : 300,
                    height:50,
                    child:
                ElevatedButton(
                    onPressed: () async {
                      if (_key.currentState!.validate()) {
                        String title =   _titleController.text;
                        String categorie = _categorieController.text;
                         String etat = _etatController.text;
                         String adresse= _adresseController.text;
                         String phone = _phoneController.text;
                          String description = _descriptionController.text;
                           String image = _imageController.text;
      
                        //Create the Map of data
                        Map<String,String> dataToUpdate={
                          'title':title,
                          'categorie':selectedCategorie,
                          'etat':selectedEtat,
                          'description':description,
                          'phone' :phone,
                          'adresse' : adresse,
                          'image': _imageURL,
                        };
                        //Call update()
                        _reference.update(dataToUpdate);
                  Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DonDetails(data['id']), // Passer l'identifiant de l'élément à afficher
                        ),
                      );
       ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.green,
      content: Text('Données modifiées avec succès!',),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
      elevation: 4,
    ),
  );
                      }
                    },
                    child: Text('Modifier'),
                    style: ElevatedButton.styleFrom(primary: kPrimaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}