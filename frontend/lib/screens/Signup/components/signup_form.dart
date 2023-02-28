
import 'package:adawati/models/register_request_model.dart';
import 'package:adawati/screens/Signup/components/or_divider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
//import'package:adawati/screens/Signup/components/socal_sign_up.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
//import 'package:http/http.dart' as http;
import '../../Login/login_screen.dart';
import 'package:adawati/config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:adawati/services/api_service.dart';
import 'package:firebase_core/firebase_core.dart';


class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState()=> _SignUpFormState();
}
class _SignUpFormState extends State<SignUpForm>{
    
 TextEditingController emailController = TextEditingController();
 TextEditingController passwordController = TextEditingController();
   TextEditingController nameController = TextEditingController();
   bool _isNotValidate = false;
  Future<UserCredential> signInWithFacebook() async {
  // Trigger the sign-in flow
  final LoginResult loginResult = await FacebookAuth.instance.login();

  // Create a credential from the access token
  final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

  // Once signed in, return the UserCredential
  return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
}
  @override
  Widget build(BuildContext context) {
    return Form(
    
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (name) {},
            
            // ignore: prefer_const_constructors
            decoration: InputDecoration(
          errorText: _isNotValidate ?"Veuillez entrer UserName":null,
              hintText: "NomPrenom",
              // ignore: prefer_const_constructors
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person_outline,color:Color.fromARGB(255, 189, 188, 188),),
              ),
             
            ),
            
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            onSaved: (email){},
              cursorColor: kPrimaryColor,
              // ignore: prefer_const_constructors
              decoration: InputDecoration(
               errorText: _isNotValidate ?"Veuillez entrer votre email":null,
                hintText: "Adresse email",
                // ignore: prefer_const_constructors
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
             child: Icon(Icons.email_outlined,color:Color.fromARGB(255, 189, 188, 188),),
                ),
              ),
            ),
          ),
              Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
controller: passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              // ignore: prefer_const_constructors
              decoration: InputDecoration(
                   errorText: _isNotValidate ?"Veuillez entrer un mot de passe (au moins 6 caractéres)":null,
                hintText: "Your password",
                // ignore: prefer_const_constructors
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                child:const Icon(Icons.lock_outline,color:Color.fromARGB(255, 189, 188, 188),),
          ),
                ),
              ),
            ),
          
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            onPressed:(){
              FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: emailController.text,
                 password: passwordController.text,
                 ).then((value) {
                  Fluttertoast.showToast(
  msg: "Compte créer avec succés",
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,
  backgroundColor: Colors.green,
  textColor: Colors.white,
);
                  print("Compte créer avec succes");
Navigator.push(context,
MaterialPageRoute(builder: (context)=>LoginScreen()));
                 }).onError((error, stackTrace) {
                Fluttertoast.showToast(
  msg: "les informations d'identification invalides",
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,
  backgroundColor: Colors.red,
  textColor: Colors.white,
);
                  print("Error ${error.toString()}");
                 });
            
      /*  if(validateAndSave()){
        setState(() {
          isApiCallProcess=true;
        });
RegisterRequestModel model = LoginRequestModel(
                    password: password !,
                    email: email !,
                     );
        APIService.register(model).then(
          (response) {
            setState(() {
              isApiCallProcess=false;
            });
            if(response.data !=null){
              FormHelper.showSimpleAlertDialog(
                context,
                Config.appName,
                "Inscription validée, veuillez connecter",
                "ok",
                (){
                  Navigator.pushNamedAndRemoveUntil(context, 
                 '/', (route) => false,
                 );
                },
              );
            }else{
              FormHelper.showSimpleAlertDialog(context,
              Config.appName,
              response.message,
              "ok",
              (){
                Navigator.of(context).pop();
              },
              );
            }
          },
          ),
        }*/
            
           
  }, child: Text("S`inscrire".toUpperCase())),

          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
          OrDivider (),
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
     SocalIcon(
      iconSrc: "assets/icons/facebook.svg",
      press:() async{
      await  signInWithFacebook();
      },
    ),

],
)

        ],
      ),
    );
  }

}

class SocalIcon extends StatelessWidget {
  final String iconSrc;
  final Function press;
  const SocalIcon({
    Key? key,
     required this.iconSrc,
     required this.press,
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: kPrimaryLightColor,
          ),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
       iconSrc,
        height: 20,
        width: 20,
        ),
      ),
    );
  }
}
