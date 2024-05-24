import 'package:flutter/material.dart';
//import 'package:newfoodexpress/constant.dart';
//import 'package:newfoodexpress/model/allinonboardscreen.dart';
import 'package:flutter/cupertino.dart';

class AllinOnboardModel {
  String imgStr;
  String description;
  String titlestr;
  AllinOnboardModel(this.imgStr, this.description, this.titlestr);
}

class PageBuilderWidget extends StatelessWidget {
  String titlestr;
  String description;
  String imgurl;
  PageBuilderWidget({
    super.key,
    required this.titlestr,
    required this.description,
    required this.imgurl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Image.asset(
              imgurl,
              height: 200, // Set your desired height here
              width: 200,  // Set your desired width here
              fit: BoxFit.contain, // Adjust the fit as needed
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          // Title Text
          Text(
            titlestr,
            style: TextStyle(
              color: primarygreen,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          // Description
          Text(
            description,
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: primarygreen,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}


class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}




Color lightgreenshede = Color(0xFFF0FAF6);
Color lightgreenshede1 = Color(0xFFB2D9CC);
Color greenshede0 = Color(0xFF66A690);
Color greenshede1 = Color(0xFF93C9B5);
Color primarygreen = Color(0xFF1E3A34);
Color grayshade = Color(0xFF93B3AA);
Color colorAcent = Color(0xFF78C2A7);
Color cyanColor = Color(0xFF6D7E6E);

const kAnimationDuration = Duration(milliseconds: 200);

class _OnboardScreenState extends State<OnboardScreen> {
  int currentIndex = 0;
  final PageController _pageController = PageController();

  List<AllinOnboardModel> allinonboardlist = [
    AllinOnboardModel(
      "assets/images/designf.jpg",
      "There are many variations of passages of Lorem Ipsum available. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary",
      "Prepared by experts",
    ),
    AllinOnboardModel(
      "assets/images/designt.jpeg",
      "There are many variations of passages of Lorem Ipsum available. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary",
      "Delivery to your home",
    ),
    AllinOnboardModel(
      "assets/images/designt.jpeg",
      "There are many variations of passages of Lorem Ipsum available. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary",
      "Enjoy with everyone",
    ),
  ];

  // Function to navigate to the next page
  void nextPage() {
    if (currentIndex < allinonboardlist.length - 1) {
      currentIndex++;
      _pageController.animateToPage(
        currentIndex,
        duration: kAnimationDuration,
        curve: Curves.ease,
      );
    }
  }

  // Function to navigate to the previous page
  void previousPage() {
    if (currentIndex > 0) {
      currentIndex--;
      _pageController.animateToPage(
        currentIndex,
        duration: kAnimationDuration,
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Your Scaffold widget
      body: Stack(
        children: [
          // Your existing widgets
          PageView.builder(
            controller: _pageController,
            onPageChanged: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            itemCount: allinonboardlist.length,
            itemBuilder: (context, index) {
              return PageBuilderWidget(
                titlestr: allinonboardlist[index].titlestr,
                description: allinonboardlist[index].description,
                imgurl: allinonboardlist[index].imgStr,
              );
            },
          ),
          // Your existing Positioned widgets
          // Navigation buttons
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: previousPage, // Navigate to previous page
                  child: Text(
                    "Previous",
                    style: TextStyle(fontSize: 18, color: primarygreen),
                  ),
                  // Your existing ElevatedButton styles
                ),
                ElevatedButton(
                  onPressed: nextPage, // Navigate to next page
                  child: Text(
                    "Next",
                    style: TextStyle(fontSize: 18, color: primarygreen),
                  ),
                ),
                //ElevatedButton(
                  //onPressed: nextPage, // Navigate to next page
                  //child: Text(
                    //"Getting",
                    //style: TextStyle(fontSize: 18, color: primarygreen),
                  //),
                  // Your existing ElevatedButton styles
                //),
              ],
            ),
          ),
          // Your existing Positioned widget for "Get Started" button
        ],
      ),
    );
  }
}
