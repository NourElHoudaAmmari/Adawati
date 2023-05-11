import 'package:adawati/helpers/constants.dart';
import 'package:adawati/models/demande_model.dart';
import 'package:adawati/screens/demande/demande_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditDemandeScreen extends StatefulWidget {
    final DocumentSnapshot demande;

  const EditDemandeScreen({Key? key, required this.demande})
      : super(key: key);
  @override
  State<EditDemandeScreen> createState() => _EditDemandeScreenState();
}

class _EditDemandeScreenState extends State<EditDemandeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;

  @override
  void get initState{
    super.initState;
    _descriptionController =
        TextEditingController(text: widget.demande['description']);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: kontColor,
        title: Text('Modifier demande',
        style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
        ),
      ),
      
      body: Padding(
        
        padding: const EdgeInsets.all(16.0),
        
        child: Form(
          
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 50,),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
        
              const SizedBox(height: 16.0),
              ElevatedButton(
                               style: ElevatedButton.styleFrom(
    backgroundColor: kontColor ,
  ),
             onPressed: () {
  if (_formKey.currentState!.validate()) {
    final updatedDemande = DemandeModel(
      id: widget.demande.id,
      description: _descriptionController.text,
          userId: widget.demande['userId'],
              userName: widget.demande['userName'], 
              userEmail: widget.demande['userEmail'],
              
    );

    FirebaseFirestore.instance
        .collection('demande')
        .doc(widget.demande.id)
        .update(updatedDemande.toMap());

   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Modification effectuée avec succès!'),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green,
    ));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DemandeScreen(),
      ),
    );
  }
},
                child: Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}