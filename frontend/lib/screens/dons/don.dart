import 'package:adawati/helpers/constants.dart';
import 'package:adawati/screens/dons/don_list.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:core';
import 'dart:io';
class DonPage extends StatefulWidget {
  const DonPage({super.key});

  @override
  State<DonPage> createState() => _DonPageState();
}
class _DonPageState extends State<DonPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
 final _descriptionController = TextEditingController();
 final _categorieController=TextEditingController();
   final _adresseController = TextEditingController();
  final _etatController = TextEditingController();
   final _phoneController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;
  String selectedEtat="0";
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
        final etat = selectedEtat;
      final categorie=selectedCategorie;
           final adresse = _adresseController.text.trim();
            final phone = _phoneController.text.trim();
      final imageDownloadUrl = await _uploadImageToStorage(_imageFile!);
      final user =FirebaseAuth.instance.currentUser;
      final userId = user!= null? user.uid :null;
         String? userName = user?.displayName;
      await FirebaseFirestore.instance.collection('dons').add({
        'title': title,
       'description':description,
       'categorie':categorie,
       'etat': etat,
       'adresse': adresse,
       'phone':phone,
        'image': imageDownloadUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'favourites':[],
      });
      setState(() {
        _isLoading = false;
      });
      Navigator.push(context,
    MaterialPageRoute(builder: (context) => DonList()),
      );
               ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.green,
      content: Text(
        'Don ajouté',
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _etatController.dispose();
    _adresseController.dispose();
    _categorieController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
  bool isCompleted = false;
  List<Step>stepList()=>[
    Step(
      
      state: _activeStepIndex > 0 ? StepState.complete : StepState.disabled,
      isActive: _activeStepIndex >=0,
      title: Text('Informations générales'), 
    content: Column(
      children: <Widget>[
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
    Padding(padding: EdgeInsets.all(8.0)),
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
      return 'Veuillez entrer une adresse';
    }
    return null;
  },
),
  ],
),
      ],
    )
    ),
    Step(
      state: _activeStepIndex > 1 ? StepState.complete : StepState.disabled,
      isActive: _activeStepIndex >=1,
      title: Text('Details'),
     content: Column(
      children:<Widget> [
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
 // crossAxisAlignment: CrossAxisAlignment.start,
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
   keyboardType: TextInputType.number,
    maxLength: 8,
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
      ],
     )),
  ];
  int _activeStepIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: 
        
        Text(
          "Ajouter un don",
          style: TextStyle(color:Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
        
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
       body:Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: kontColor),
        ),
        child: Form(
          key: _formKey,
          child: 
       Stepper(
        type: StepperType.horizontal,
        currentStep: _activeStepIndex,
        steps: stepList(),
      onStepContinue: () {
        final isLastStep = _activeStepIndex == stepList().length -1;
        _formKey.currentState!.validate();
        bool isDetailValid = isDetailComplete();
        if(isDetailValid){
   if(isLastStep){
    _addDon();

          setState(() {
            
            isCompleted = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.green,
      content: Text(
        'Don ajouté',
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
        }else{
          setState(() {
            _activeStepIndex += 1;
          });
        }
        }
     
          
        },
        onStepTapped: (step){
          _formKey.currentState!.validate();
          setState(() {
            _activeStepIndex = step;
          });
        },
      onStepCancel: () {
          if (_activeStepIndex == 0) {
            return;
          }
          setState(() {
            _activeStepIndex -= 1;
          });
        
        },
controlsBuilder: (context, details,{onStepContinue, onStepCancel}) {
  final isLastStep = _activeStepIndex == stepList().length -1;
  return Container(
    margin: EdgeInsets.only(top: 50),
    child: Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
    backgroundColor: kPrimaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
            ),
                   onPressed:_isLoading ? null :details.onStepContinue,
            child:
            _isLoading
? CircularProgressIndicator(
valueColor: AlwaysStoppedAnimation(Colors.grey),
): Text(isLastStep ? 'Confirmer':'Suivant'),
            ),
          ),
          const SizedBox(width: 12),
          if(_activeStepIndex !=0)
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
    backgroundColor: kontColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
              child:Text('Annuler') ,
              onPressed: details.onStepCancel,
              ),
            ),
      ],
    ),
  );
},
        ),
        ),
       ),
    );
  }
  bool isDetailComplete(){
    if(_activeStepIndex ==0){
      if(_titleController.text.isEmpty || _descriptionController.text.isEmpty || _adresseController.text.isEmpty){
        return false;
      }else{
        return true;
      }
    }else if (_activeStepIndex ==1){
      if(_phoneController.text.isEmpty){
        return false;
      }else{
        return true;
      }
    }
    return false;
  }
  
  
}