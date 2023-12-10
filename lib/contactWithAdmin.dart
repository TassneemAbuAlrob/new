import 'dart:convert';
import 'dart:io';

import 'package:google_fonts/google_fonts.dart';
import 'package:webfront/mainParent.dart';
import 'package:webfront/parentProfile.dart';
import 'package:webfront/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

Map<String, dynamic> userData = {};
TextEditingController profilePictureController = TextEditingController();
TextEditingController nameController = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController emailController = TextEditingController();

File? myfile;
//to fetch photo&name
Future<Map<String, dynamic>> fetchUserData(String email) async {
  final response = await http
      .get(Uri.parse('http://192.168.1.112:3000/showchildprofile/$email'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load user data');
  }
}

class contactWithAdmin extends StatefulWidget {
  @override
  _contactWithAdminState createState() => _contactWithAdminState();
}

class _contactWithAdminState extends State<contactWithAdmin> {
  var _titleTextStyle = TextStyle(
    fontSize: 26,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );
  var contentTextStyle = TextStyle(
      fontSize: 18,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.bold,
      color: Colors.grey);

  @override
  void initState() {
    super.initState();

    // fetchUserData(UserServices.getEmail()).then((data) {
    fetchUserData('tassiyad@gmail.com').then((data) {
      setState(() {
        userData = data;
        String baseUrl = "http://192.168.1.112:3000";
        String imagePath = "uploads";
        String imageUrl =
            baseUrl + "/" + imagePath + "/" + userData['profilePicture'];
        nameController.text =
            userData.containsKey('name') ? userData['name'] : '';
        profilePictureController.text =
            userData.containsKey('profilePicture') ? imageUrl : '';
        phoneController.text = userData.containsKey('phoneNumber')
            ? userData['phoneNumber'].toString()
            : '';
        emailController.text =
            userData.containsKey('email') ? userData['email'] : '';
      });
    });
  }

  bool _isLoading = false;

  String joinedAt = " ";
  bool _isSameUser = false;
  var width, height;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      // drawer: DrawerWidget(),
      appBar: AppBar(
        elevation: 0.0,
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            decoration: BoxDecoration(
              color: Colors.white, // Set background color to white
              border: Border.all(
                color: Color.fromRGBO(
                    229, 239, 240, 0.89), // Set border color to black
                width: 5, // Set border width
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            Text(
              "BrainyBaddies",
              style: GoogleFonts.oswald(
                textStyle: TextStyle(
                  color: Color.fromARGB(255, 55, 164, 241),
                  fontSize: 25,
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => mainParent()),
                      );
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          AssetImage('images/homeicon.jpg') as ImageProvider,
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => parentProfile()),
                      );
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          AssetImage('images/avatar.jpg') as ImageProvider,
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                  GestureDetector(
                    onTap: () {
                      // Navigate to the main page here
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => childProfile()),
                      // );
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          AssetImage('images/chaticon.jpg') as ImageProvider,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Stack(
                  children: [
                    Card(
                      margin: EdgeInsets.all(30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 100,
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: Text(
                                    nameController.text == null
                                        ? 'Name here'
                                        : nameController.text!,
                                    style: _titleTextStyle)),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Contact Info :',
                              style: _titleTextStyle,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: userInfo(
                                  title: 'Email:',
                                  content: emailController.text),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: userInfo(
                                  title: 'Phone number:',
                                  content: phoneController.text),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            _isSameUser
                                ? Container()
                                : Divider(
                                    thickness: 1,
                                  ),
                            SizedBox(
                              height: 20,
                            ),
                            _isSameUser
                                ? Container()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      _contactBy(
                                        color: Colors.green,
                                        fct: () {
                                          _openWhatsAppChat();
                                        },
                                        icon: FontAwesome.whatsapp,
                                      ),
                                      _contactBy(
                                          color: Colors.red,
                                          fct: () {
                                            _mailTo();
                                          },
                                          icon: Icons.mail_outline),
                                      _contactBy(
                                          color: Colors.purple,
                                          fct: () {
                                            _callPhoneNumber();
                                          },
                                          icon: Icons.call_outlined),
                                    ],
                                  ),
                            SizedBox(
                              height: 25,
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            !_isSameUser
                                ? Container()
                                : Center(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 30),
                                      child: MaterialButton(
                                        onPressed: () {
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) => UserState(),
                                          //   ),
                                          // );
                                        },
                                        color: Colors.pink.shade700,
                                        elevation: 8,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(13)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.logout,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                'Logout',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 70.0,
                          backgroundImage: myfile != null
                              ? FileImage(myfile!)
                              : profilePictureController.text.isNotEmpty
                                  ? NetworkImage(profilePictureController.text)
                                      as ImageProvider
                                  : AssetImage('images/background.gif')
                                      as ImageProvider,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }

  void _openWhatsAppChat() async {
    var url = 'https://wa.me/${phoneController.text}?text=HelloWorld';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Error');
      throw 'Error occurred';
    }
  }

  void _mailTo() async {
    var mailUrl = 'mailto:${emailController.text}';
    if (await canLaunch(mailUrl)) {
      await launch(mailUrl);
    } else {
      print('Erorr');
      throw 'Error occured';
    }
  }

  void _callPhoneNumber() async {
    var url = 'tel://${phoneController.text}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Error occured';
    }
  }

  Widget _contactBy(
      {required Color color, required Function fct, required IconData icon}) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: CircleAvatar(
          radius: 23,
          backgroundColor: Colors.white,
          child: IconButton(
            icon: Icon(
              icon,
              color: color,
            ),
            onPressed: () {
              fct();
            },
          )),
    );
  }

  Widget userInfo({required String title, required String content}) {
    return Row(
      children: [
        Text(
          title,
          style: _titleTextStyle,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            content,
            style: contentTextStyle,
          ),
        ),
      ],
    );
  }
}
