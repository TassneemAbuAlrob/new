import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:webfront/services/user_services.dart';

TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController phoneNumberController = TextEditingController();
TextEditingController profilePictureController = TextEditingController();

//show and fetch data
Future<Map<String, dynamic>> fetchUserData(String email) async {
  final response = await http
      .get(Uri.parse('http://192.168.1.112:3000/showprentprofile/$email'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load user data');
  }
}

//editing data
Future<void> updateUserProfile(
  String email,
  Map<String, dynamic> updatedData,
  File? profilePicture,
) async {
  try {
    final uri = Uri.parse('http://192.168.1.112:3000/editparentprofile/$email');
    var request = http.MultipartRequest('POST', uri);
    if (profilePicture != null) {
      var image = await http.MultipartFile.fromPath(
          "profilePicture", profilePicture.path);
      request.files.add(image);
    }

    updatedData.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    var response = await request.send();

    if (response.statusCode == 200) {
    } else {
      throw Exception(
          'Failed to update user data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error updating user data: $e');
    throw Exception('Failed to update user data. Error: $e');
  }
}

class parentEdit extends StatefulWidget {
  @override
  _parentEditState createState() => _parentEditState();
}

class _parentEditState extends State<parentEdit> {
  File? myfile;
  Map<String, dynamic> userData = {};
  var height, width;

  @override
  void initState() {
    super.initState();
    fetchUserData(UserServices.getEmail()).then((data) {
      setState(() {
        userData = data;
        String baseUrl = "http://192.168.1.112:3000";
        String imagePath = "uploads";
        String imageUrl =
            baseUrl + "/" + imagePath + "/" + userData['profilePicture'];
        nameController.text =
            userData.containsKey('name') ? userData['name'] : '';
        emailController.text =
            userData.containsKey('email') ? userData['email'] : '';
        phoneNumberController.text = userData.containsKey('phoneNumber')
            ? userData['phoneNumber'].toString()
            : '';
        profilePictureController.text =
            userData.containsKey('profilePicture') ? imageUrl : '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.07),
          color: Colors.white,
          constraints: const BoxConstraints.expand(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(244, 245, 245, 0.886),
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
                                      : profilePictureController.text.isNotEmpty
                                          ? NetworkImage(
                                              profilePictureController.text)
                                          : AssetImage('images/background.gif')
                                              as ImageProvider,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 114, left: 70),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                    ),
                                    child: IconButton(
                                      onPressed: () async {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) => Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  205, 245, 250, 0.898),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                color: Color.fromARGB(
                                                    255, 55, 164, 241),
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
                                                          ImageSource.gallery,
                                                    );
                                                    if (xfile != null) {
                                                      setState(() {
                                                        myfile =
                                                            File(xfile.path);
                                                      });
                                                    }
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    width: double.infinity,
                                                    padding: EdgeInsets.all(10),
                                                    child: Text(
                                                      "Choose Image From Gallery",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Color.fromARGB(
                                                            255, 55, 164, 241),
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                          ImageSource.camera,
                                                    );
                                                    if (xfile != null) {
                                                      setState(() {
                                                        myfile =
                                                            File(xfile.path);
                                                      });
                                                    }
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    width: double.infinity,
                                                    padding: EdgeInsets.all(10),
                                                    child: Text(
                                                      "Choose Image From Camera",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Color.fromARGB(
                                                            255, 55, 164, 241),
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                        Icons.edit,
                                        color:
                                            Color.fromARGB(255, 55, 164, 241),
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
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          suffixIcon: Icon(
                            Icons.person,
                            color: Colors.grey,
                          ),
                        ),
                        controller: nameController,
                      ),
                      SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          suffixIcon: Icon(
                            Icons.email,
                            color: Colors.grey,
                          ),
                        ),
                        controller: emailController,
                      ),
                      SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          suffixIcon: Icon(
                            Icons.phone,
                            color: Colors.grey,
                          ),
                        ),
                        controller: phoneNumberController,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.INFO,
                              animType: AnimType.SCALE,
                              title: 'Confirmation',
                              desc: 'Are you sure you want to save the edits?',
                              btnCancelOnPress: () {
                                // Cancel action
                              },
                              btnOkOnPress: () async {
                                final updatedData = {
                                  'name': nameController.text,
                                  'email': emailController.text,
                                  'phoneNumber': phoneNumberController.text,
                                };

                                if (myfile != null) {
                                  updatedData['profilePicture'] = myfile!.path
                                      .split('/')
                                      .last; // Store the image name
                                } else {
                                  updatedData['profilePicture'] =
                                      profilePictureController.text;
                                }

                                await updateUserProfile(
                                    userData['email'], updatedData, myfile);

                                // Close the dialog
                                Navigator.of(context).pop();
                              },
                            )..show();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue[800],
                            minimumSize: Size(100, 40),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.check_box),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Save Edit')
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            nameController.text = userData.containsKey('name')
                                ? userData['name']
                                : '';
                            emailController.text = userData.containsKey('email')
                                ? userData['email']
                                : '';
                            phoneNumberController.text =
                                userData.containsKey('phoneNumber')
                                    ? userData['phoneNumber'].toString()
                                    : '';

                            myfile = null;
                            profilePictureController.text =
                                userData.containsKey('profilePicture')
                                    ? userData['profilePicture']
                                    : '';
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            minimumSize: Size(100, 40),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.cancel),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Cancel Edit')
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
