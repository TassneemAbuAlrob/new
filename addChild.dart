import 'dart:convert';
import 'dart:io';

import 'package:finalfrontproject/parentProfile.dart';
import 'package:finalfrontproject/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

File? myfile;
final TextEditingController fullNameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController phoneNumberController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();

class addIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/addchildicon.jpg',
      width: 35,
      height: 35,
    );
  }
}

class addChild extends StatefulWidget {
  @override
  _addChildState createState() => _addChildState();
}

class _addChildState extends State<addChild> {
  var height, width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: width,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(),
                height: height * 0.23,
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 35,
                        left: 20,
                        right: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                        left: 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              addIcon(),
                              SizedBox(width: 25),
                              Text(
                                'Add Your Child',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.paprika(
                                  fontSize: 30,
                                  color: Color.fromARGB(255, 55, 164, 241),
                                  fontWeight: FontWeight.bold,
                                  shadows: const [
                                    Shadow(
                                      color: Color.fromARGB(191, 158, 158, 158),
                                      offset: Offset(2, 2),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(205, 245, 250, 0.898),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(180),
                        // topRight: Radius.circular(35),
                      ),
                      border: Border.all(
                        color: Color.fromARGB(191, 158, 158, 158),
                        width: 4.0,
                      ),
                    ),
                    width: width,
                    child: Padding(
                      padding: EdgeInsets.all(50.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(205, 245, 250, 0.898),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    alignment: Alignment.topCenter,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 4),
                                        child: CircleAvatar(
                                          radius: 74.0,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            radius: 60.0,
                                            backgroundImage: myfile != null
                                                ? FileImage(myfile!)
                                                : profilePictureController
                                                        .text.isNotEmpty
                                                    ? NetworkImage(
                                                        profilePictureController
                                                            .text)
                                                    : AssetImage(
                                                            'images/background.gif')
                                                        as ImageProvider,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 114, left: 70),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(1),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50)),
                                              ),
                                              child: IconButton(
                                                onPressed: () async {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) =>
                                                        Container(
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            205,
                                                            245,
                                                            250,
                                                            0.898),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                        border: Border.all(
                                                          color: Color.fromARGB(
                                                              255,
                                                              55,
                                                              164,
                                                              241),
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          InkWell(
                                                            onTap: () async {
                                                              final xfile =
                                                                  await ImagePicker()
                                                                      .pickImage(
                                                                source:
                                                                    ImageSource
                                                                        .gallery,
                                                              );
                                                              if (xfile !=
                                                                  null) {
                                                                setState(() {
                                                                  myfile = File(
                                                                      xfile
                                                                          .path);
                                                                });
                                                              }
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: double
                                                                  .infinity,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              child: Text(
                                                                "Choose Image From Gallery",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          55,
                                                                          164,
                                                                          241),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontFamily:
                                                                      "MyCustomFont",
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () async {
                                                              final xfile =
                                                                  await ImagePicker()
                                                                      .pickImage(
                                                                source:
                                                                    ImageSource
                                                                        .camera,
                                                              );
                                                              if (xfile !=
                                                                  null) {
                                                                setState(() {
                                                                  myfile = File(
                                                                      xfile
                                                                          .path);
                                                                });
                                                              }
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: double
                                                                  .infinity,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              child: Text(
                                                                "Choose Image From Camera",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          55,
                                                                          164,
                                                                          241),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontFamily:
                                                                      "MyCustomFont",
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.add_a_photo,
                                                  color: Color.fromARGB(
                                                      255, 55, 164, 241),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: fullNameController,
                            style: GoogleFonts.mada(
                              color: Color.fromARGB(255, 55, 164, 241),
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              labelStyle: GoogleFonts.mada(
                                color: Color.fromARGB(191, 158, 158, 158),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Color.fromARGB(191, 158, 158, 158),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 119, 119, 119),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(191, 158, 158, 158),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: emailController,
                            style: GoogleFonts.mada(
                              color: Color.fromARGB(255, 55, 164, 241),
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: GoogleFonts.mada(
                                color: Color.fromARGB(191, 158, 158, 158),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              prefixIcon: Icon(
                                Icons.email, // Add your email icon here
                                color: Color.fromARGB(191, 158, 158, 158),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 119, 119, 119),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(191, 158, 158, 158),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: phoneNumberController,
                            style: GoogleFonts.mada(
                              color: Color.fromARGB(255, 55, 164, 241),
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle: GoogleFonts.mada(
                                color: Color.fromARGB(191, 158, 158, 158),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              prefixIcon: Icon(
                                Icons.phone,
                                color: Color.fromARGB(191, 158, 158, 158),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 119, 119, 119),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(191, 158, 158, 158),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: passwordController,
                            style: GoogleFonts.mada(
                              color: Color.fromARGB(255, 55, 164, 241),
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              labelText: 'Password',
                              labelStyle: GoogleFonts.mada(
                                color: Color.fromARGB(191, 158, 158, 158),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              prefixIcon: Icon(
                                Icons.lock, // Add your password icon here
                                color: Color.fromARGB(191, 158, 158, 158),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 119, 119, 119),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(191, 158, 158, 158),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: confirmPasswordController,
                            style: GoogleFonts.mada(
                              color: Color.fromARGB(255, 55, 164, 241),
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              labelText: 'Confirm Password',
                              labelStyle: GoogleFonts.mada(
                                color: Color.fromARGB(191, 158, 158, 158),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              prefixIcon: Icon(
                                Icons
                                    .lock, // Add your confirm password icon here
                                color: Color.fromARGB(191, 158, 158, 158),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 119, 119, 119),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(191, 158, 158, 158),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            height: height * 0.1,
                            width: width,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 230, 230, 230),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(35),
                                  topRight: Radius.circular(35),
                                  bottomLeft: Radius.circular(35),
                                  bottomRight: Radius.circular(35)),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color.fromARGB(116, 134, 100, 136)
                                          .withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 5,
                                  offset: const Offset(10, 10),
                                ),
                              ],
                            ),
                            margin: const EdgeInsets.only(
                                left: 60, right: 60, bottom: 20),
                            child: ElevatedButton(
                              onPressed: () async {
                                final fullName = fullNameController.text;
                                final email = emailController.text;
                                final phoneNumber = phoneNumberController.text;
                                final password = passwordController.text;
                                final confirmPassword =
                                    confirmPasswordController.text;

                                // Regular expression to check for a valid email format
                                final emailRegExp = RegExp(
                                    r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

                                if (fullName.isEmpty ||
                                    !emailRegExp.hasMatch(
                                        email) || // Check email format
                                    phoneNumber.isEmpty ||
                                    password.isEmpty ||
                                    confirmPassword.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Please fill in all fields with valid data'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                // Check if the passwords match
                                if (password != confirmPassword) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Passwords do not match'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                final response = await http.post(
                                  Uri.parse(
                                      'http://192.168.1.112:3000/addChild/${UserServices.getEmail()}'),
                                  headers: {'Content-Type': 'application/json'},
                                  body: jsonEncode({
                                    'name': fullName,
                                    'email': email,
                                    'phoneNumber': phoneNumber,
                                    'password': password,
                                    'confirmPassword': confirmPassword,
                                    'profilePicture': myfile != null
                                        ? myfile?.path.split('/').last
                                        : '',
                                  }),
                                );

                                if (response.statusCode == 201) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('add child successful'),
                                      backgroundColor:
                                          Color.fromARGB(213, 46, 247, 76),
                                    ),
                                  );

                                  // Clear the text fields
                                  fullNameController.text = '';
                                  emailController.text = '';
                                  phoneNumberController.text = '';
                                  passwordController.text = '';
                                  confirmPasswordController.text = '';
                                  setState(() {
                                    myfile = null;
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('add child failed'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(90),
                                  side: BorderSide(
                                      color: Color.fromARGB(191, 158, 158, 158),
                                      width: 1.5),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Add',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 55, 164, 241),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
