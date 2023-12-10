import 'dart:convert';
import 'dart:io';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:webfront/OnBoardingPage.dart';
import 'package:webfront/childPostpage.dart';
import 'package:webfront/childProfile.dart';
import 'package:webfront/childProfileEdit.dart';
import 'package:webfront/editprofilechildpage.dart';
import 'package:webfront/followersList.dart';
import 'package:webfront/followingListPage.dart';
import 'package:webfront/mainChild.dart';
import 'package:webfront/services/user_services.dart';
import 'package:webfront/yourpostList.dart';

TextEditingController profilePictureController = TextEditingController();
TextEditingController nameController = TextEditingController();
var defaultBackgroundColor = Colors.grey[300];
var myDrawer;
var drawerTextColor = TextStyle(
  color: Colors.grey[600],
);
var tilePadding = const EdgeInsets.only(left: 8.0, right: 8, top: 8);

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

class followerListPage extends StatefulWidget {
  const followerListPage({Key? key}) : super(key: key);

  @override
  _followerListPageState createState() => _followerListPageState();
}

class _followerListPageState extends State<followerListPage> {
  File? myfile;
  File? myfile2;
  Emoji? selectedEmoji;
  Map<String, dynamic> userData = {};
  List<Map<String, dynamic>> posts = [];
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
        profilePictureController.text =
            userData.containsKey('profilePicture') ? imageUrl : '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    int selectedIndex = 0;
    return Scaffold(
      backgroundColor: Colors.white,
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
                        MaterialPageRoute(
                            builder: (context) => followerListPage()),
                      );
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          AssetImage('images/followers.jpg') as ImageProvider,
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => followingListPage()),
                      );
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          AssetImage('images/following.jpg') as ImageProvider,
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                  GestureDetector(
                    onTap: () {
                      // Navigate to the main page here
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => childProfile()),
                      );
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          AssetImage('images/post.jpg') as ImageProvider,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // open drawer
            myDrawer = Drawer(
              backgroundColor: Color.fromRGBO(229, 239, 240, 0.89),
              elevation: 0,
              child: Column(
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(229, 239, 240, 0.89),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: myfile != null
                              ? FileImage(myfile!)
                              : profilePictureController.text.isNotEmpty
                                  ? NetworkImage(profilePictureController.text)
                                      as ImageProvider
                                  : AssetImage('images/background.gif')
                                      as ImageProvider,
                        ),
                        SizedBox(height: 8),
                        Text(
                          nameController.text,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: tilePadding,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => childPostpage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue[800],
                              minimumSize: Size(80, 40),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.add_circle_rounded),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Add Post')
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: tilePadding,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        editprofilechildpage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey,
                              minimumSize: Size(80, 40),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.edit),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Edit Profile')
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: tilePadding,
                    child: ListTile(
                      leading: Icon(Icons.home),
                      title: Text(
                        'D A S H B O A R D',
                        style: drawerTextColor,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => mainChild()),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: tilePadding,
                    child: ListTile(
                      leading: Icon(Icons.chat_bubble),
                      title: Text(
                        'C H A T',
                        style: drawerTextColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: tilePadding,
                    child: ListTile(
                      leading: Icon(Icons.notification_add),
                      title: Text(
                        'N O T I F I C A T I O N',
                        style: drawerTextColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: tilePadding,
                    child: ListTile(
                      leading: Icon(Icons.info),
                      title: Text(
                        'A B O U T',
                        style: drawerTextColor,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => IntroScreen()),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: tilePadding,
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text(
                        'L O G O U T',
                        style: drawerTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              flex: 7,
              child: followersList(),
            ),
          ],
        ),
      ),
    );
  }
}

///
