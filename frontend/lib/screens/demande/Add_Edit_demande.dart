import 'package:adawati/controllers/demande_controller.dart';
import 'package:adawati/helpers/constants.dart';
import 'package:adawati/models/demande_model.dart';
import 'package:adawati/screens/demande/demande_screen.dart';
import 'package:adawati/screens/demande/form_edit.dart';
import 'package:flutter/material.dart';

class MyPopup extends StatelessWidget {
  const MyPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 100,
        height: 200,
       
      ),
    );
  }
}
 
class AddEditDemande extends StatefulWidget {
 final DemandeModel? demande;
final index;
AddEditDemande({this.demande, this.index,});

  @override
  State<AddEditDemande> createState() => _AddEditDemandeState();
}

class _AddEditDemandeState extends State<AddEditDemande> {
 final _form_Key = GlobalKey<FormState>();
  bool isedit = false;
  final TextEditingController description = TextEditingController();
  final TextEditingController id = TextEditingController();


  @override
  void init(){
    if(widget.index != null){
      isedit = true;
     id.text = widget.demande?.id;
     description.text = widget.demande?.description;
    }
    else{
      isedit = false;
    }
    super.initState;
  }
   @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
        title: Center(child: 
        
        Text(
           isedit == true ? "Modifier demande" : "Ajouter demande",
          style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
        ),
        ),
        elevation: 0.0,

        backgroundColor: kPrimaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
       Navigator.of(context).pop();
        },
        ),
        // backgroundColor: Colors.transparent,
      
      
       ),

        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
               Center(
                child: isedit == true
                 ? const Text("Modifier demande",style: TextStyle(fontSize: 28,color: kontColor,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),)
                   :const Text("Ajouter demande",style: TextStyle(fontSize: 28,color: kontColor,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),)
                
              
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                    key: _form_Key,
                    child: Column(
                      children: [
                        FormEdit(
                          labledText: "Description",
                          mycontroller: description,
                        )
                      ],
                    )),
              ),
              const SizedBox(height: 26),
            
              SizedBox(
                width: 200,
                child: ElevatedButton(
                style: ElevatedButton.styleFrom(
    backgroundColor: kontColor ,
  ),
                    onPressed: () {
                     
                      if (_form_Key.currentState!.validate()) {
                        _form_Key.currentState!.save();
                        if(isedit == true){
                          DemandeController().update_demande(DemandeModel(
                            id : id.text,
                            description: description.text));
                        }
                           else{
                           DemandeController().add_demande(DemandeModel(
                            description: description.text)
              
                           );
                        }
                       Navigator.push(context, 
                       MaterialPageRoute(builder: (context)=>DemandeScreen()));
                      }
                    
                    },
                    child: isedit == true ?  Text("Modifier",style: TextStyle(fontSize: 20)) : Text("Publier",style: TextStyle(fontSize: 20))
                  
                    )
              )
            ],
          ),
        )));
  }
}