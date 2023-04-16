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
  final _adresseController = TextEditingController();
  final _categorieController = TextEditingController();

  bool _isLoading = false;
  String selectedCategorie="0";

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _adresseController.dispose();
    _categorieController.dispose();
   
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
              value:categories["name"],
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
  onPressed: () {
    if (_formKey.currentState!.validate()) {
      // Tous les champs sont remplis, rediriger vers la page suivante
      Navigator.push(context, MaterialPageRoute(builder: (context) =>AddDetailsDon()));
    } else {
      // Afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
    }
  },
  child: Text('Suivant'),
),

],
),
),
),
);
}
}





