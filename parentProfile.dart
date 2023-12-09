import 'dart:convert';
import 'dart:io';

import 'package:finalfrontproject/childProfileForParent.dart';
import 'package:finalfrontproject/parentEdit.dart';
import 'package:finalfrontproject/perantDash.dart';
import 'package:finalfrontproject/screens/welcome/welcome_screen.dart';
import 'package:finalfrontproject/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

TextEditingController profilePictureController = TextEditingController();
TextEditingController nameController = TextEditingController();

//to fetch photo&name
Future<Map<String, dynamic>> fetchUserData(String email) async {
  final response = await http
      .get(Uri.parse('http://192.168.1.112:3000/showprentprofile/$email'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load user data');
  }
}

class parentProfile extends StatefulWidget {
  @override
  _parentProfileState createState() => _parentProfileState();
}

class _parentProfileState extends State<parentProfile> {
  Map<String, dynamic> userData = {};
  final List<Map<String, dynamic>> _listItem = [];
  File? myfile;

  //fetch children
  Future<void> fetchChildrenData(String parentEmail) async {
    try {
      final response = await http.get(
          Uri.parse('http://192.168.1.112:3000/fetchChildren/$parentEmail'));
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> childData =
            (json.decode(response.body) as List).cast<Map<String, dynamic>>();
        setState(() {
          _listItem.clear();
          _listItem.addAll(childData);
        });
      } else {}
    } catch (error) {}
  }

  @override
  void initState() {
    super.initState();

    // fetchUserData(UserServices.getEmail()).then((data) {
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
    fetchChildrenData(UserServices.getEmail());
  }

//number of children
  Future<int> getChildCount() async {
    final response = await http.get(
      Uri.parse(
          'http://192.168.1.112:3000/countChildUsers/${UserServices.getEmail()}'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['count'];
    } else {
      throw Exception('Failed to load child count');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(189, 224, 220, 220),
                Color.fromRGBO(205, 245, 250, 0.898),
              ],
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 73),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PerantDash(),
                            ),
                          );
                        },
                        child: Icon(
                          AntDesign.arrowleft,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => welcomeScreen(),
                            ),
                          );
                        },
                        child: Icon(
                          AntDesign.logout,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Container(
                    height: height * 0.43,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double innerHeight = constraints.maxHeight;
                        double innerWidth = constraints.maxWidth;
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: innerHeight * 0.72,
                                width: innerWidth,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 80,
                                    ),
                                    Text(
                                      nameController
                                          .text, // Display the text from nameController
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontFamily: 'kanit',
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 55, 164, 241),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Number of your children:',
                                              style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 156, 155, 155),
                                                fontFamily: 'Nunito',
                                                fontSize: 18,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            FutureBuilder<int>(
                                              future: getChildCount(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return CircularProgressIndicator();
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                } else {
                                                  return Text(
                                                    snapshot.data.toString(),
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 55, 164, 241),
                                                      fontFamily: 'Nunito',
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(90),
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
                                                        .text) as ImageProvider
                                                : AssetImage(
                                                        'images/background.gif')
                                                    as ImageProvider,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: height * 0.5,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => parentEdit()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 55, 164, 241),

                              // minimumSize: Size(100, 40),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.edit),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Edit Your Profile')
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 2.5,
                          ),
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              children: _listItem
                                  .map((child) => GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  childProfileForParent(
                                                name: child['name'],
                                                email: child['email'],
                                                profilePicture:
                                                    child['profilePicture'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Card(
                                          color: Colors.transparent,
                                          elevation: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    child['profilePicture']),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
