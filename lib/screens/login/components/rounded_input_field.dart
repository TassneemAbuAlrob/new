//email field
import 'package:flutter/material.dart';
import 'package:webfront/constants.dart';
import 'package:webfront/screens/login/components/text_field_container.dart';
import 'package:webfront/user.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData iconData; // Changed the parameter name
  final ValueChanged<String> onChanged;
  final User user; // Add the user parameter here

  const RoundedInputField({
    Key? key, // Use 'Key?' for the key parameter
    required this.hintText,
    this.iconData = Icons.person, // Changed the parameter name
    required this.onChanged,
    required this.user, // Accept the User object as a parameter
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        // Use TextFormField instead of TextField
        controller: TextEditingController(text: user.email),
        onChanged: (value) {
          user.email = value;
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Enter something';
          } else if (RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value!)) {
            return null;
          } else {
            return 'Enter valid email';
          }
        },
        decoration: InputDecoration(
          icon: Icon(
            iconData, // Use the corrected parameter name
            color: Color.fromARGB(255, 141, 199, 241),
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
