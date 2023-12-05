import 'package:finalfrontproject/videoPlayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class videoList extends StatelessWidget {
  videoList({Key? key}) : super(key: key);

  final AppController2 homeController = Get.put(AppController2());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            AppBar(
              backgroundColor: Color.fromARGB(0, 152, 150, 150),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.black,
              ),
            ),
            const MyAppBar(),

            /// Main Body
            Expanded(
              flex: 7,
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),

                  /// TapBar
                  Expanded(flex: 1, child: _buildTabBar()),
                  const SizedBox(
                    height: 25,
                  ),

                  Expanded(
                    flex: 9,
                    child: Obx(() {
                      if (homeController.flag.value == 1) {
                        return _buildVideoTypeOne();
                      } else {
                        return SizedBox.shrink();
                      }
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Custom TabBar
  Widget _buildTabBar() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: homeController.orders.length,
      itemBuilder: (ctx, i) {
        return Obx(
          () => GestureDetector(
            onTap: () {
              homeController.flag.value = i + 1; // Update the flag
              homeController.selectedIndex.value = i;
            },
            child: AnimatedContainer(
              margin: EdgeInsets.fromLTRB(i == 0 ? 15 : 5, 0, 5, 0),
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    i == homeController.selectedIndex.value ? 15 : 9,
                  ),
                ),
                color: i == homeController.selectedIndex.value
                    ? Color.fromARGB(228, 205, 245, 250)
                    : Color.fromARGB(255, 200, 193, 193),
              ),
              duration: const Duration(milliseconds: 200),
              child: Center(
                child: Text(
                  homeController.orders[i],
                  style: GoogleFonts.ubuntu(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: i == homeController.selectedIndex.value
                        ? Color.fromARGB(255, 117, 114, 114)
                        : Color.fromARGB(255, 55, 164, 241),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //video type1

  Widget _buildVideoTypeOne() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          ReadingListCard(
            cover: "images/video1.jpg",
            title: "First video",
            rating: 3.0,
          ),
          ReadingListCard(
            cover: "images/story2.jpg",
            title: "Second video",
            rating: 3.9,
          ),
          SizedBox(width: 30),
        ],
      ),
    );
  }
}

//App Bar
class MyAppBar extends StatelessWidget {
  const MyAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Expanded(
      flex: 3,
      child: Container(
        width: size.width,
        height: size.height / 3.5,
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2),
              BlendMode.darken,
            ),
            image: const AssetImage('images/videocover.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 15.0),
              child: Text(
                "What will we watch\n Today?",
                textAlign: TextAlign.center,
                style: GoogleFonts.ubuntu(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(227, 175, 229, 236),
                  shadows: const [
                    Shadow(
                      color: Color.fromARGB(255, 7, 26, 63),
                      offset: Offset(2, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// controller

class AppController2 extends GetxController {
  var selectedIndex = 0.obs;
  var flag = 0.obs;

  List<String> orders = [
    "Religious Videos",
    "Scientific Videos",
    "Cultural Videos",
  ];
}

//stories
class ReadingListCard extends StatelessWidget {
  final String cover;
  final String title;
  final double rating;

  const ReadingListCard({
    Key? key,
    required this.cover,
    required this.title,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 24, bottom: 40),
      height: 245,
      width: 202,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 221,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(29),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 33,
                    color: Color(0xFFD3D3D3).withOpacity(.84),
                  ),
                ],
              ),
            ),
          ),
          Image.asset(
            cover,
            width: 150,
          ),
          Positioned(
            top: 35,
            right: 10,
            child: Column(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                  ),
                  onPressed: () {},
                ),
                videoRating(score: rating),
                IconButton(
                  icon: Icon(
                    Icons.play_circle_filled,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerPage(
                          title: title,
                          cover: cover,
                          rating: rating,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 160,
            child: Container(
              height: 85,
              width: 202,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Spacer(),
                  Row(children: <Widget>[
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 0),
                        width: 101,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                      ),
                    ),
                  ]),
                  Padding(
                    padding: EdgeInsets.only(left: 24),
                    child: RichText(
                      maxLines: 2,
                      text: TextSpan(
                        style: TextStyle(color: Color(0xFF393939)),
                        children: [
                          TextSpan(
                            text: "$title\n",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//rating

class videoRating extends StatelessWidget {
  final double score;
  const videoRating({
    Key? key,
    required this.score,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            offset: Offset(3, 7),
            blurRadius: 20,
            color: Color(0xFD3D3D3).withOpacity(.5),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.star,
            color: Color(0xFFF48A37),
            size: 15,
          ),
          SizedBox(height: 5),
          Text(
            "$score",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
