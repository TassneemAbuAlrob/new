import 'dart:convert';
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webfront/childProfile.dart';
import 'package:webfront/userList.dart';

TextEditingController profilePictureController = TextEditingController();
TextEditingController nameController = TextEditingController();
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

class mainChild extends StatefulWidget {
  @override
  _mainChildState createState() => _mainChildState();
}

class _mainChildState extends State<mainChild> {
  File? myfile2;
  Emoji? selectedEmoji;
  Map<String, dynamic> userData = {};
  List<Map<String, dynamic>> posts = [];
  var height, width;

  @override
  void initState() {
    super.initState();
    // fetchUserData(UserServices.getEmail()).then((data) {
    fetchUserData("tassiyad@gmail.com").then((data) {
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
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Color(0xFFF8FBFF),
        Color(0xFFFCFDFD),
      ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[NavBar(), Body()],
          ),
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      key: UniqueKey(), // Add a key here if needed
      largeScreen: LargeChild(),
    );
  }
}

class LargeChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FractionallySizedBox(
            alignment: Alignment.centerRight,
            widthFactor: .6,
            child: Image.network("images/home.jpg", scale: .85),
          ),
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: .6,
            child: Padding(
              padding: EdgeInsets.only(left: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Hello!",
                      style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Montserrat-Regular",
                          color: Color(0xFF8591B0))),
                  RichText(
                    text: TextSpan(
                        text: "WellCome To ",
                        style:
                            TextStyle(fontSize: 60, color: Color(0xFF8591B0)),
                        children: [
                          TextSpan(
                              text: "BrainyBuddies",
                              style: TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue))
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 20),
                    child: Text("LET’S EXPLORE THE WORLD",
                        style: TextStyle(color: Colors.blue)),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

//
class NavBar extends StatelessWidget {
  final navLinks = [
    "Stories",
    "Videos",
    "Games",
    "Discover",
    "Contact",
  ];
  void navigateToPage(BuildContext context, String pageName) {
    switch (pageName) {
      case "Stories":
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => StoriesPage()),
        // );
        break;
      case "Videos":
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => StoriesPage()),
        // );
        break;
      case "Games":
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => StoriesPage()),
        // );
        break;
      case "Discover":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => userList()),
        );
        break;
      case "Contact":
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => StoriesPage()),
        // );
        break;
    }
  }

  List<Widget> navItem(BuildContext context) {
    return navLinks.map((text) {
      return Padding(
        padding: EdgeInsets.only(left: 18),
        child: InkWell(
          onTap: () => navigateToPage(context, text),
          child: Text(
            text,
            style: TextStyle(
                fontFamily: "Montserrat-Bold",
                color: const Color.fromARGB(255, 70, 106, 136),
                fontSize: 20),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 45, vertical: 38),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 243, 192, 218),
                      Color.fromRGBO(205, 245, 250, 0.898),
                    ], begin: Alignment.bottomRight, end: Alignment.topLeft)),
                child: Center(
                  child: Text("B",
                      style: TextStyle(fontSize: 30, color: Colors.blue)),
                ),
              ),
              SizedBox(
                width: 2,
              ),
              Text("rainyBuddies",
                  style: TextStyle(fontSize: 26, color: Colors.blue))
            ],
          ),
          if (!ResponsiveLayout.isSmallScreen(context))
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ...navItem(context),
                GestureDetector(
                  onTap: () {
                    // Navigate to the profile page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => childProfile()),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 90,
                    height: 90,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: myfile != null
                          ? FileImage(myfile!)
                          : profilePictureController.text.isNotEmpty
                              ? NetworkImage(profilePictureController.text)
                                  as ImageProvider
                              : AssetImage('images/background.gif')
                                  as ImageProvider,
                    ),
                  ),
                ),
              ],
            )
          else
            Image.network("assets/menu.png", width: 26, height: 26)
        ],
      ),
    );
  }
}

//
class SendBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xFFC86DD7),
              Color(0xFF3023AE),
            ], begin: Alignment.bottomRight, end: Alignment.topLeft),
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                  color: Color(0xFF6078ea).withOpacity(.3),
                  offset: Offset(0.0, 8.0),
                  blurRadius: 8.0)
            ]),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Notify",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Montserrat-Bold",
                          fontSize:
                              ResponsiveLayout.isSmallScreen(context) ? 12 : 16,
                          letterSpacing: 1.0)),
                  SizedBox(
                    width: ResponsiveLayout.isSmallScreen(context) ? 4 : 8,
                  ),
                  Image.network(
                    "assets/sent.png",
                    color: Colors.white,
                    width: ResponsiveLayout.isSmallScreen(context) ? 12 : 20,
                    height: ResponsiveLayout.isSmallScreen(context) ? 12 : 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
//

class ResponsiveLayout extends StatelessWidget {
  final Widget largeScreen;

  const ResponsiveLayout({required Key key, required this.largeScreen})
      : super(key: key);

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 800;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 800;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return largeScreen;
      },
    );
  }
}
