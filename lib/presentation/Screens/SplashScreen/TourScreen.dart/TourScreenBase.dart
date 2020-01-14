import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/Screens/SplashScreen/TourScreen.dart/FinishTourPage.dart';
import 'package:handball_flutter/presentation/Screens/SplashScreen/WelcomeScreen.dart/GetStartedPage.dart';
import 'package:handball_flutter/presentation/Screens/SplashScreen/WelcomeScreen.dart/PageIndicator.dart';
import 'package:handball_flutter/presentation/Screens/SplashScreen/WelcomeScreen.dart/OnboardingPage.dart';

class TourScreenBase extends StatefulWidget {
  @override
  _TourScreenBaseState createState() => _TourScreenBaseState();
}

class _TourScreenBaseState extends State<TourScreenBase> {
  PageController _pageController;
  int _currentPageIndex;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(8),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color.fromARGB(255, 0, 11, 19),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Text('Skip'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
          Expanded(
              child: PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() {
              _currentPageIndex = index;
            }),
            children: <Widget>[
              OnboardingPage(
                  image: Image(
                    image: AssetImage('assets/images/tour/tour_01.png'),
                  ),
                  headline: 'Amet officia',
                  detail:
                      'Aute velit nostrud reprehenderit consequat do aute. Laboris adipisicing occaecat est et occaecat amet ea ex sunt in aute.'),
              OnboardingPage(
                  image: Image(
                    image: AssetImage('assets/images/tour/tour_02.png'),
                  ),
                  headline: 'Ex laborum enim fugiat ex.',
                  detail:
                      'Non aliquip est consequat occaecat reprehenderit est. Laboris adipisicing occaecat est et occaecat amet'),
              OnboardingPage(
                  image: Image(
                    image: AssetImage('assets/images/tour/tour_03.png'),
                  ),
                  headline:
                      'Nulla culpa velit laboris ea tempor quis id sunt ad.',
                  detail:
                      'Veniam duis esse incididunt proident voluptate commodo. Nulla ipsum irure reprehenderit amet dolor quis magna.'),
              FinishTourPage()
            ],
          )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child:
                PageIndicator(currentPageIndex: _currentPageIndex, pageQty: 4),
          )
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
