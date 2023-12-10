import 'package:webfront/mainParent.dart';
import 'package:webfront/parentProfile.dart';
import 'package:webfront/showInterest.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Score {
  final String gameName;
  final int sumScore;

  Score({required this.gameName, required this.sumScore});

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      gameName: json['gameName'],
      sumScore: json['totalScore'],
    );
  }
}

class ScoreTable extends StatefulWidget {
  final String email;

  ScoreTable({required this.email});

  @override
  _ScoreTableState createState() => _ScoreTableState();
}

class _ScoreTableState extends State<ScoreTable> {
  List<Score> scoresAnimals = [];
  List<Score> scoresFruits = [];

  @override
  void initState() {
    super.initState();
    fetchData1();
    fetchData2();
  }

  Future<void> fetchData1() async {
    final Uri url =
        Uri.parse('http://192.168.1.112:3000/getsum/${widget.email}/Animals');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      dynamic responseData = json.decode(response.body);

      print('Response Data: $responseData');

      if (responseData != null && responseData['totalScore'] != null) {
        int totalScore = responseData['totalScore'];

        setState(() {
          scoresAnimals.add(Score(gameName: 'Animals', sumScore: totalScore));
        });
      } else {
        print('Invalid or empty response data');
        throw Exception('Invalid or empty response data');
      }
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchData2() async {
    final Uri url =
        Uri.parse('http://192.168.1.112:3000/getsum/${widget.email}/Fruits');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      dynamic responseData = json.decode(response.body);

      print('Response Data: $responseData');

      if (responseData != null && responseData['totalScore'] != null) {
        int totalScore = responseData['totalScore'];

        setState(() {
          scoresFruits.add(Score(gameName: 'Fruits', sumScore: totalScore));
        });
      } else {
        print('Invalid or empty response data');
        throw Exception('Invalid or empty response data');
      }
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
        children: [
          _buildDataTable('Animals', scoresAnimals),
          // SizedBox(height: 40),
          _buildDataTable('Fruits', scoresFruits),
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 239, 151, 180),
              onPrimary: Colors.white,
              fixedSize: Size(300.0, 50.0),
            ),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowInterest(email: widget.email)),
              );
            },
            child: Text("Back"),
          ),
          SizedBox(
            width: 200,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 239, 151, 180),
              onPrimary: Colors.white,
              fixedSize: Size(300.0, 50.0),
            ),
            onPressed: () async {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => ScoreTable(email: widget.email)),
              // );
            },
            child: Text("Next"),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(String gameName, List<Score> scores) {
    return Padding(
      padding: EdgeInsets.only(top: 100.0), // Adjust the top margin as needed
      child: Center(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromRGBO(205, 245, 250, 0.898),
                width: 5,
              ),
            ),
            child: DataTable(
              columns: [
                DataColumn(
                  label: Text(
                    'Game Name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Sum Score',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
              rows: scores.map((score) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        gameName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        score.sumScore.toString(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
