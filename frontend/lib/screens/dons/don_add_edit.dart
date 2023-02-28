// ignore_for_file: sort_child_properties_last

import 'dart:ui';

import 'package:adawati/services/don_service.dart';
import 'package:adawati/config.dart';
import 'package:adawati/models/don_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'dart:io';

import 'package:snippet_coder_utils/hex_color.dart';

class DonAddEdit extends StatefulWidget {
  const DonAddEdit({super.key});

  @override
  State<DonAddEdit> createState() => _DonAddEditState();
}

class _DonAddEditState extends State<DonAddEdit> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool isAPICallProcess =false;
  DonModel? donModel;
  bool isEditMode = false;
  bool isImageSelected = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
appBar: AppBar(
  title: const Text("Publier un don"),
  elevation: 0,
),
backgroundColor: Colors.grey[200],
body: ProgressHUD(
  child:Form(
    key: globalKey,
    child:donForm(),
  ),
 inAsyncCall : isAPICallProcess,
 opacity: .3,
key:UniqueKey(),
),
      ),
    );
  }
  @override
  void initState(){
    super.initState();
    donModel = DonModel();
    Future.delayed(Duration.zero,(){
 if(ModalRoute.of(context)?.settings.arguments !=null){
      final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
      donModel = arguments["model"];
      isEditMode = true;
      setState(() {
        
      });
    }
    });
   
  }
  Widget donForm(){
    return SingleChildScrollView(
      child:Column(
        mainAxisAlignment: MainAxisAlignment.start,
crossAxisAlignment: CrossAxisAlignment.start,
children: [
  Padding(
    padding: const EdgeInsets.only(
      bottom: 10,
      top: 10
    ),
    child: FormHelper.inputFieldWidget(
      context,
       "DonName" ,
       "Don Name" ,
    // const Icon(Icons.ac_unit) ,
      
       (onValidateVal){
if(onValidateVal.isEmpty){
  return 'DonName can`t be empty';
}
return null;
       },
       (onSavedVal){
        donModel!.donTitre = onSavedVal;
       },
      initialValue: donModel!.donTitre??"",
    
       borderColor: Colors.black,
       borderFocusColor: Colors.black,
       textColor: Colors.black,
       hintColor: Colors.black.withOpacity(.7),
       borderRadius: 10,
       showPrefixIcon: false,
      
        ),
  ),
  Padding(
    padding: const EdgeInsets.only(
      bottom: 10,
      top: 10
    ),
    child: FormHelper.inputFieldWidget(
      context,
      // const Icon(Icons.ac_unit) 
       "DonDescription" ,
       "Don Description" ,
       (onValidateVal){
if(onValidateVal.isEmpty){
  return 'DonDescription can`t be empty';
}
return null;
       },
         (onSavedVal){
        donModel!.donDescription = onSavedVal;
       },
      initialValue: donModel!.donDescription??"",
       borderColor: Colors.black,
       borderFocusColor: Colors.black,
       textColor: Colors.black,
       hintColor: Colors.black.withOpacity(.7),
       borderRadius: 10,
       showPrefixIcon: false,
      
        ),
  ),
  picPicker(isImageSelected,donModel!.donImage??"",(file){
    setState(() {
       donModel!.donImage=file.path;
    isImageSelected = true;
    });
  }),
  const SizedBox(
    height: 20,
  ),
  Center(child: FormHelper.submitButton("Save", (){
    if(validateAndSave()){
setState(() {
  isAPICallProcess = true;
});
APIService.saveDon(donModel!, isEditMode,isImageSelected).then(
  (response){
setState(() {
  isAPICallProcess=false;
});
if(response){
  Navigator.pushAndRemoveUntil(
    context,
   '/' as Route<Object?> ,
   (route) => false,
   );
}
else{
  FormHelper.showSimpleAlertDialog(
    context, 
    Config.appName,
    "Erreur Occure",
      "ok",
      (){
        Navigator.of(context).pop();
      });
}
  },
);
    }
  },
  btnColor: HexColor("#283B71"),
  borderColor: Colors.white,
  borderRadius: 10
  ),
  ),

],
      ),
    );
  }
  bool validateAndSave(){
    final form = globalKey.currentState;
    if(form!.validate()){
      form.save();
      return true;
    }
    return false;
  }
  static Widget picPicker(
    bool isFileSelected,
    String fileName,
    Function onFilePicked,
  ){
    Future<XFile?> _imageFile;
    ImagePicker _picker = ImagePicker();

    return Column(
      children: [
        fileName.isNotEmpty?
        isFileSelected ? Image.file(File(fileName),height: 200,width: 200,)
        : SizedBox(child: Image.network(fileName,width: 200,height: 200,fit: BoxFit.scaleDown,),)
       : SizedBox(child: Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png",width: 200,height: 200,fit: BoxFit.scaleDown,
       ),
       ),
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    SizedBox(
      height: 35.0,
      width: 35.0,
      child: IconButton(
        padding: const EdgeInsets.all(0),
        icon: const Icon(
          Icons.image,
          size: 35,
        ),
        onPressed: (){
          _imageFile = _picker.pickImage(source: ImageSource.gallery);
          _imageFile.then((file) async{
            onFilePicked(file);
          });
        },
      ),
    ),
     SizedBox(
      height: 35.0,
      width: 35.0,
      child: IconButton(
        padding: const EdgeInsets.all(0),
        icon: const Icon(
          Icons.camera,
          size: 35,
        ),
        onPressed: (){
          _imageFile = _picker.pickImage(source: ImageSource.camera);
          _imageFile.then((file) async{
            onFilePicked(file);
          });
        },
      ),
    ),
  ],
)
      ],
    );
  }

}