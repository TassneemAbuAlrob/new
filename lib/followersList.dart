import 'dart:convert';

import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http_parser/http_parser.dart' as http;
import 'package:http/http.dart' as http;
import 'package:webfront/profileOtherChild.dart';
import 'package:webfront/profileOtherChildpage.dart';

class rainbowIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/followers.jpg',
      width: 30,
      height: 30,
    );
  }
}

class followersList extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _followersListState createState() => _followersListState();
}

class _followersListState extends State<followersList> {
  final List<Map<String, dynamic>> _listItem = [];
  var width, height;
  Future<void> fetchFollowers(String email) async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.1.112:3000/followers/$email'));
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> followerData =
            (json.decode(response.body) as List).cast<Map<String, dynamic>>();
        setState(() {
          _listItem.clear();
          _listItem.addAll(followerData);
        });
      } else {}
    } catch (error) {}
  }

  @override
  void initState() {
    super.initState();
    // fetchFollowers(UserServices.getEmail());
    fetchFollowers("tassiyad@gmail.com");
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(229, 239, 240, 0.89),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Container(
                width: width * 0.4,
                height: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: AssetImage('images/followers.jpg'),
                        fit: BoxFit.cover)),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient:
                          LinearGradient(begin: Alignment.bottomRight, colors: [
                        Colors.black.withOpacity(.4),
                        Colors.black.withOpacity(.2),
                      ])),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "YOUR FOLLOWERS :",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: Center(
                            child: Text(
                          "Let's see who follows you :)",
                          style: TextStyle(
                              color: Color.fromARGB(255, 55, 164, 241),
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  children: _listItem
                      .map((follower) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => profileOtherChildpage(
                                    name: follower['name'],
                                    email: follower['email'],
                                    profilePicture: follower['profilePicture'],
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.transparent,
                              elevation: 0,
                              child: Container(
                                // width: 100,
                                // height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 100,
                                      backgroundImage: NetworkImage(
                                          follower['profilePicture']),
                                    ),
                                    SizedBox(height: 10),
                                  ],
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
      ),
    );
  }
}
