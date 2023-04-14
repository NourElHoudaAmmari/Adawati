import 'package:flutter/material.dart';

import '../../../helpers/constants.dart';
import '../../Login/login_screen.dart';
import '../../Signup/signup_screen.dart';

class LoginAndSignupBtn extends StatelessWidget {
  const LoginAndSignupBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: "login_btn",
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(kontColor),
            ),
            child: Text(
              "Se Connecter".toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SignUpScreen();
                },
              ),
            );
          },
          style: ElevatedButton.styleFrom(
              primary: kPrimaryColor, elevation: 0),
          child: Text(
            "S`inscrire".toUpperCase(),
            style: const TextStyle(color:
             Colors.white,
             fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}