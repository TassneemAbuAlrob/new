import 'package:google_fonts/google_fonts.dart';
import 'package:webfront/mainChild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:webfront/components/rounded_button.dart';
import 'package:webfront/mainParent.dart';
import 'package:webfront/screens/login/components/alreadyHaveAccout.dart';
import 'package:webfront/screens/login/components/background.dart';
import 'package:webfront/screens/login/components/roundedPassField.dart';
import 'package:webfront/screens/login/components/rounded_input_field.dart';
import 'package:webfront/services/user_services.dart';
import 'package:webfront/user.dart';
import 'package:http/http.dart' as http;

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class body extends StatelessWidget {
  body({
    super.key,
  });
  User user = User('', ''); // Declare the user object here

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    User user = User('', '');
    return background(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "L O G I N",
                style: GoogleFonts.odibeeSans(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 55, 164, 241),
                  fontSize: 30,
                ),
              ),
              SvgPicture.asset(
                "android/icons/log1.svg",
                height: size.height * 0.5,
              ),

              RoundedInputField(
                hintText: "Your Email",
                onChanged: (value) {},
                user: user, // Pass the user object here
              ),

              RoundedPasswordField(
                onChanged: (value) {},
                user: user, // Pass the user object here
              ),
//--------------------------------------------
              RoundedButton(
                text: "LOG IN",
                color: Color.fromARGB(255, 141, 199, 241),
                press: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await UserServices.login(
                        email: user.email,
                        password: user.password,
                      );

                      String? profileType = UserServices.getProfileType();
                      if (profileType == 'child') {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => mainChild()),
                        );
                      } else {
                        if (profileType == 'parent') {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => mainParent()),
                          );
                        }
                      }
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error.toString())),
                      );
                    }
                  } else {
                    print("not ok");
                  }
                },
              ),

//-----------------------------------
              AlreadyHaveAnAccountChecked(
                press: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
