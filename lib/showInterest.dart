import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:webfront/mainParent.dart';
import 'package:webfront/parentProfile.dart';

class ShowInterest extends StatefulWidget {
  final String email;

  ShowInterest({required this.email});

  @override
  _ShowInterestState createState() => _ShowInterestState();
}

class _ShowInterestState extends State<ShowInterest> {
  Map<String, dynamic> interestData = {
    'religious': 0.0,
    'scientific': 0.0,
    'cultural': 0.0,
  };

  @override
  void initState() {
    super.initState();
    // Fetch interests when the page is opened
    fetchInterests();
  }

  Future<void> fetchInterests() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.112:3000/getInterests/${widget.email}'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(response.body)['interests'];

        // Parse values as doubles before updating interestData
        final Map<String, double> parsedData = {};
        responseData.forEach((key, value) {
          parsedData[key] = double.tryParse(value.toString()) ?? 0.0;
        });

        setState(() {
          interestData = parsedData;
        });
      } else {
        // Handle errors
        print('Failed to fetch interests. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors
      print('Error fetching interests: $error');
    }
  }

  Widget _buildCircularIndicator(String label, double percent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircularPercentIndicator(
              animation: true,
              animationDuration: 10000,
              radius: 100,
              lineWidth: 40,
              percent: percent,
              progressColor: Color.fromARGB(255, 53, 202, 236),
              backgroundColor: Color.fromARGB(226, 160, 235, 245),
              circularStrokeCap: CircularStrokeCap.round,
            ),
            Text(
              '$label: ${(percent * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 8, 125, 151),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 233, 233, 240),
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
                  SizedBox(width: 50),
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
                  SizedBox(width: 50),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 200, right: 200),
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircularIndicator(
                    "Religious", interestData['religious'] / 100),
                SizedBox(width: 50),
                _buildCircularIndicator(
                    "Scientific", interestData['scientific'] / 100),
                SizedBox(width: 50),
                _buildCircularIndicator(
                    "Cultural", interestData['cultural'] / 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
