import 'dart:io';
import 'package:adawati/helpers/constants.dart';
import 'package:adawati/screens/Login/login_screen.dart';
import 'package:adawati/screens/dons/don_list.dart';
import 'package:adawati/screens/dons/donadd_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddDon extends StatefulWidget {
 const AddDon({Key? key}) : super(key: key);

  @override
  State<AddDon> createState() => _AddDonState();
}

class _AddDonState extends State<AddDon> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
 final _descriptionController = TextEditingController();
  final _etatController = TextEditingController();
  final _niveauController = TextEditingController();
  final _adresseController = TextEditingController();
  final _categorieController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;
  String selectedCategorie="0";

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
        final etat = _etatController.text.trim();
         final niveau = _niveauController.text.trim();
           final adresse = _adresseController.text.trim();
               final categorie = _categorieController.text.trim();
               final phone= _phoneController.text.trim();
      final imageDownloadUrl = await _uploadImageToStorage(_imageFile!);
      await FirebaseFirestore.instance.collection('dons').add({
        'title': title,
       'description':description,
       'etat': etat,
       'phone': phone,
       'categorie': categorie,
       'adresse': adresse,
       'niveau':niveau,
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
    _categorieController.dispose();
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
    MaterialPageRoute(builder: (context) => DonList()),
         ); },
        ),  
       ),
     
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              Center(
  child: Text(
    '1. Informations générales',
    style: TextStyle(
      color: Colors.black,
      fontStyle: FontStyle.italic,
      fontSize: 18,
    ),
  ),
),
              SizedBox(height: 30,),
            
       Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Titre',
      style: TextStyle(
        color: Colors.grey[700],
        fontSize: 18,
      ),
    ),
    SizedBox(height: 10,),
 TextFormField(
  controller: _titleController,
  decoration: InputDecoration(
    hintText: 'Ex: Livre de lecture 5éme année primaire',
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
      return 'Veuillez entrer le titre';
    }
    return null;
  },
),
  ],
),
 SizedBox(height: 18),
  Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Description',
      style: TextStyle(
        color: Colors.grey[700],
        fontSize: 18,
      ),
    ),
    SizedBox(height: 10,),
     // définir la hauteur souhaitée du TextFormField
     TextFormField(
        controller: _descriptionController,
        decoration: InputDecoration(
          hintText: 'Ex: Je mets en don un livre ....',
          contentPadding: EdgeInsets.symmetric(vertical: 55.0), // définir la marge interne de la zone de saisie
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
        maxLines: null, // permet à l'utilisateur d'écrire autant de lignes qu'il souhaite
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez entrer une description';
          }
          return null;
        },
      ),
   
  ],
),
 SizedBox(height: 18),
 Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Categorie',
      style: TextStyle(
        fontSize: 18,
        color: Colors.grey[700],
      ),
    ),
    SizedBox(height: 10,),
    StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (context,snapshot){
        List<DropdownMenuItem>categorieItems=[];
        if(!snapshot.hasData){
          return const CircularProgressIndicator();
        }else{
          final categories = snapshot.data?.docs.reversed.toList();
          categorieItems.add(
            const DropdownMenuItem(
              value: "0",
              child: Text('Categorie sélectionnée'),
              ),
          );
          for(var categories in categories!){
            categorieItems.add(DropdownMenuItem(
              value:categories.id ,
              child:Text(
             categories['name'],
              ),
              ),
              );
          }
        }
        return DropdownButton(
          items: categorieItems,
           onChanged: (categorieValue){
            setState(() {
              selectedCategorie=categorieValue;
            });
          print(categorieValue);
        },
        value: selectedCategorie,
        isExpanded: false,
        );
      }
    ),
  ],
),
  SizedBox(height: 18,),
       Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Adresse',
      style: TextStyle(
        color: Colors.grey[700],
        fontSize: 18,
      ),
    ),
    SizedBox(height: 10,),
 TextFormField(
  controller: _adresseController,
  decoration: InputDecoration(
    hintText: 'Ex: Tunis, Tunisie',
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
      return 'Veuillez entrer le titre';
    }
    return null;
  },
),
  ],
),

      
 SizedBox(height: 30),

ElevatedButton(
  onPressed: _isLoading ? null : () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddDetailsDon()),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: kPrimaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  child: _isLoading
      ? CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
        )
      : Text('Suivant',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
),

],
),
),
),
);
}
}





