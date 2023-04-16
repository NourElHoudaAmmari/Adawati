import 'package:adawati/screens/dons/add_don.dart';
import 'package:adawati/screens/dons/don_list.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:adawati/helpers/constants.dart';
import 'package:flutter/material.dart';

class AddDetailsDon extends StatefulWidget {
  const AddDetailsDon({super.key});

  @override
  State<AddDetailsDon> createState() => _AddDetailsDonState();
}

class _AddDetailsDonState extends State<AddDetailsDon> {
   final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
 final _descriptionController = TextEditingController();
  final _etatController = TextEditingController();
  final _niveauController = TextEditingController();
  final _adresseController = TextEditingController();
   final _phoneController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;
  String selectedEtat="0";

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }
  Future<String> _uploadImageToStorage(File file) async {
    int date = DateTime.now().microsecondsSinceEpoch;
    final storageRef = FirebaseStorage.instance.ref().child('don_images$date');
    final uploadTask = storageRef.putFile(file);
    final snapshot = await uploadTask;
    return  snapshot.ref.getDownloadURL();
  }

  Future<void> _addDon() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final title = _titleController.text.trim();
       final description = _descriptionController.text.trim();
        final etat = selectedEtat;
         final niveau = _niveauController.text.trim();
           final adresse = _adresseController.text.trim();
            final phone = _phoneController.text.trim();
      final imageDownloadUrl = await _uploadImageToStorage(_imageFile!);
      await FirebaseFirestore.instance.collection('dons').add({
        'title': title,
       'description':description,
       'etat': etat,
       'adresse': adresse,
       'niveau':niveau,
       'phone':phone,
        'image': imageDownloadUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _etatController.dispose();
    _adresseController.dispose();
    _niveauController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Center(child: 
        
        Text(
          "Ajouter un don",
          style: TextStyle(color:Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
        ),
        ),
        elevation: 0.0,

        backgroundColor: kontColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
          Navigator.push(context,
    MaterialPageRoute(builder: (context) =>AddDon()),
         ); },
        ),
        // backgroundColor: Colors.transparent,
      
      
       ),
     
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              SizedBox(height: 25,),
              GestureDetector(
                onTap: () async {
                  await showModalBottomSheet(
                    context: context,
                    builder: (_) => BottomSheet(
                      onClosing: () {},
                      builder: (_) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text('Prendre une photo'),
                            leading: Icon(Icons.camera_alt),
                            onTap: () {
                              _pickImage(ImageSource.camera);
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            title: Text('Choisir depuis la galerie'),
                            leading: Icon(Icons.photo_library),
                            onTap: () {
                              _pickImage(ImageSource.gallery);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Ajouter une image',
      style: TextStyle(
        color: Colors.grey[700],
        fontSize: 16,
      ),
    ),
    SizedBox(height: 10),
    Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      height: 200,
      width: 400,
      child: _imageFile == null
          ? Icon(Icons.camera_alt_outlined, size: 60, color: Colors.grey)
          : Image.file(_imageFile!, fit: BoxFit.cover),
    ),
  ],
),
              ),
              SizedBox(height: 15),
             Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Etat',
      style: TextStyle(
        fontSize: 18,
        color: Colors.grey[700],
      ),
    ),
    SizedBox(height: 10,),
    StreamBuilder<QuerySnapshot>(
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
          for(var etats in etats!){
           etatItems.add(DropdownMenuItem(
              value:etats["libelle"] ,
              child:Text(
            etats['libelle'],
              ),
              ),
              );
          }
        }
        return DropdownButton(
          items: etatItems,
           onChanged: (etatValue){
            setState(() {
              selectedEtat=etatValue;
            });
          print(etatValue);
        },
        value: selectedEtat,
        isExpanded: false,
        );
      }
    ),
    
  ],
  
), SizedBox(height: 15),
              Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Numéro de contact',
      style: TextStyle(
        color: Colors.grey[700],
        fontSize: 18,
      ),
    ),
    SizedBox(height: 10,),
 TextFormField(
  controller: _phoneController,
  decoration: InputDecoration(
    hintText: 'Ex: 25173464',
    hintStyle: TextStyle(
      color: Colors.grey[500],
      fontSize: 14,
    ),
    filled: true, // ajouter un fond rempli de couleur
    fillColor: Colors.grey[200], // définir la couleur de l'arrière-plan
    border: OutlineInputBorder( // définir une bordure de rectangle
      borderRadius: BorderRadius.circular(8.0), // personnaliser le rayon des coins du rectangle
      borderSide: BorderSide.none, // supprimer la bordure de ligne
    ),
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un numero  de telephone';
    }
    return null;
  },
),
  ],
),
 SizedBox(height: 25),
  

ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: kPrimaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
onPressed: _isLoading ? null : _addDon,
child: _isLoading
? CircularProgressIndicator(
valueColor: AlwaysStoppedAnimation(Colors.grey),
)
: Text('Publier',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
),
],
),
),
),
);
}
}





