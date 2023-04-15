import 'package:flutter/material.dart';
class FormEdit extends StatelessWidget {
  final labledText;
  final TextEditingController mycontroller;

FormEdit({
  required this.labledText,
  required this.mycontroller, 
 // required hintText
}); 

  // ignore: empty_constructor_bodies
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: mycontroller,
      decoration:InputDecoration(
        labelText: labledText,
       contentPadding: EdgeInsets.symmetric(vertical: 55),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 3,color: Colors.blue)),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 3,color: Colors.red)),
            focusedErrorBorder: const OutlineInputBorder(borderSide: BorderSide(width: 3,color: Colors.red))
      ),
       validator: (value){
        if(value!.isEmpty){
          return "Ce champ est obligatoire.";
        }
      },
     
              
    );
  }
}
