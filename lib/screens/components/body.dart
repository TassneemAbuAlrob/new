//contains the text and bottons in the first page
import 'package:google_fonts/google_fonts.dart';
import 'package:webfront/Signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:webfront/components/rounded_button.dart';
import 'package:webfront/screens/components/background.dart';
import 'package:webfront/screens/login/login_screen.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "BrainyBaddies",
              style: GoogleFonts.odibeeSans(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 55, 164, 241),
                fontSize: 50,
              ),
            ),

            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "android/icons/welcome.svg",
              height: size.height * 0.45,
              width: size.width * 0.5,
            ),
            SizedBox(height: size.height * 0.03),

            RoundedButton(
              text: "LOGIN",
              color: Color.fromARGB(228, 205, 245, 250),
              textColor: Color.fromARGB(255, 55, 164, 241),
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
            // THIS IS FOR THE NEXT BOTTON IN THE FIRST PAGE
            RoundedButton(
              text: "SIGNUP",
              color: Color.fromARGB(228, 205, 245, 250),
              textColor: Color.fromARGB(255, 55, 164, 241),
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return RegScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
