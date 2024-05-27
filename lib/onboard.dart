import 'package:flutter/material.dart';
import 'capture_image_screen.dart';

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
    Key? key,
    required this.titlestr,
    required this.description,
    required this.imgurl,
  }) : super(key: key);

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
              height: 200,
              width: 200,
              fit: BoxFit.contain,
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
  const OnboardScreen({Key? key}) : super(key: key);

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
      body: Stack(
        children: [
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
          Visibility(
            visible: currentIndex == allinonboardlist.length - 1,
            child: Positioned(
              bottom: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    print("Getting started button clicked");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CaptureImageScreen(),
                      ),
                    );
                  },
                  child: Text('Get Started'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
