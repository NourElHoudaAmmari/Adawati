import 'dart:io';

import 'package:adawati/controllers/profile_controller.dart';
import 'package:adawati/helpers/constants.dart';
import 'package:adawati/models/user.dart';
import 'package:adawati/screens/Profile/profile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
 TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController id = TextEditingController();
   String imageUrl = '';
    

   bool isObscure = true; // Step 1: Add isObscure variable
     Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: source);
    if (image != null) {
      final File file = File(image.path);
      Reference ref = FirebaseStorage.instance.ref().child('${Path.basename(file.path)}');
     final UploadTask = ref.putFile(file);
     final snapshot =await UploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadURL;
      });
    }
  }

  File? profileImage;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kontColor,
        leading: IconButton(
          //onPressed: () =>Get.back(),
           onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                  },
        icon: const Icon(CupertinoIcons.arrowtriangle_left)),
     title: Text("Profile", style: TextStyle(color: Colors.white,fontStyle: FontStyle.italic)),
        ),
        body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: FutureBuilder(
            future: controller.getUserData(),
            builder: (context,snapshot){
              if(snapshot.connectionState == ConnectionState.done){
if(snapshot.hasData){
 User user = snapshot.data as User;
        final id = TextEditingController(text: user.id);
        final email = TextEditingController(text: user.email ?? '');
        final password = TextEditingController(text: user.password ?? '');
        final name = TextEditingController(text: user.name ?? '');
        final address = TextEditingController(text: user.address ?? '');
        final phone = TextEditingController(text: user.phone ?? '');
  return Column(
              children: [
                Stack(
                  children: [
               SizedBox(
  width: 120,
  height: 120,
  child: InkWell(
     onTap:  () async {
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
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: imageUrl == ""
                                    ? Image.asset(
                                        'assets/images/profile_pic.png')
                                    : Image.network(imageUrl),
                              ),
                            ),
                          ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                       width: 35,
                       height: 35,
                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),color: Colors.grey),
                       child: const Icon(
                      CupertinoIcons.add
                        ,color:Colors.white,
                        size: 20,
                        ),
                       ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Form(
                  child:Column(
                    children: [
                      //const SizedBox(height:9),
                        TextFormField(
                          controller: name,
                        decoration: InputDecoration(
                          label: Text("Nom & Prenom"),prefixIcon:Icon(CupertinoIcons.person_fill,color: Colors.blue)),
                      ),
                       const SizedBox(height: 9),
                        TextFormField(
                          controller:email,
                        decoration: InputDecoration(
                          label: Text("Adresse email"),prefixIcon:Icon(CupertinoIcons.envelope,color: Colors.blue)),
                      ),
                       const SizedBox(height:9),
                        TextFormField(
                          controller: phone,
                        decoration: InputDecoration(
                          label: Text("Numero de telephone"),prefixIcon:Icon(CupertinoIcons.phone,color: Colors.blue)),
                      ),
                      const SizedBox(height: 9),
                        TextFormField(
                          controller: address,
                          
                        decoration: InputDecoration(
                          hintText: 'Adresse',
                          label: Text("Addresse"),prefixIcon:Icon(CupertinoIcons.text_aligncenter,color: Colors.blue)),
                      ),
                       const SizedBox(height:9),
                        TextFormField(
                          controller: password,
                            obscureText: isObscure, // Step 3: Use isObscure value
                       
                        decoration: InputDecoration(
                          label: Text("Mot de passe"),prefixIcon:Icon(Icons.password_outlined,color: Colors.blue),
                          suffixIcon: IconButton(
                            // Step 4: Add suffix icon that toggles isObscure
                            onPressed: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                            icon: Icon(
                              isObscure ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                        const SizedBox(height:15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                        onPressed:() async {
                          String imagePath = '';
if (profileImage != null) {
Reference ref = FirebaseStorage.instance
.ref()
.child('profilepics/${Path.basename(profileImage!.path)}');
final UploadTask= ref.putFile(profileImage!);
final snapshot = await UploadTask;
imagePath = await snapshot.ref.getDownloadURL();
}
                          final userData =User(
                            id : id.text,
                           email: email.text.trim(),
                           password: password.text.trim(),
                           phone: phone.text.trim(),
                           name: name.text.trim(),
                           address: address.text.trim(),
                           profilePick: imagePath.isNotEmpty ? imagePath : imageUrl,
                           );
try {
      await controller.updateRecord(userData);
     ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Données modifiées avec succès!',),
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(top: 10, right: 10),
    elevation: 4,
  ),
);
Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
       
        SnackBar(content: Text('Une erreur s\'est produite: $e',),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(top: 10,right: 10),
        elevation: 4,
        ),
        
      );
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: kPrimaryColor,
    side: BorderSide.none,
    shape: const StadiumBorder(),
  ),
  child: const Text("Modifier Profile", style: TextStyle(color: Colors.white)),
),
                        ),
                        
                       //ElevatedButton(
                        //onPressed:(){},
                        //style: ElevatedButton.styleFrom(
                          //backgroundColor: Colors.orange.withOpacity(0.2),
                          //elevation: 0,
                          //side: BorderSide.none,
                          //shape: const StadiumBorder()),
                          //child: const Text("Cancel", style: TextStyle(color: Colors.white)),
                        // )
                    ],
                  )) 
              ]
            );
}else if(snapshot.hasError){
  return Center(child: Text(snapshot.error.toString())); 
}else{
  return const Center(child: Text("quelque chose s'est mal passé"));
}
              }else{
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        )
        )
        
    );
  }
}