import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/Screens/SplashScreen/WelcomeScreen.dart/GetStartedPage.dart';
import 'package:handball_flutter/presentation/Screens/SplashScreen/WelcomeScreen.dart/PageIndicator.dart';
import 'package:handball_flutter/presentation/Screens/SplashScreen/WelcomeScreen.dart/OnboardingPage.dart';

class WelcomeScreenBase extends StatefulWidget {
  final dynamic onCreateAccountButtonPressed;
  final dynamic onSignInButtonPressed;

  WelcomeScreenBase({
    this.onSignInButtonPressed,
    this.onCreateAccountButtonPressed,
  });

  @override
  _WelcomeScreenBaseState createState() => _WelcomeScreenBaseState();
}

class _WelcomeScreenBaseState extends State<WelcomeScreenBase> {
  PageController _pageController;
  int _currentPageIndex;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Color.fromARGB(255, 0, 11, 19),
      child: Column(children: <Widget>[
        Expanded(
            child: PageView(
          controller: _pageController,
          onPageChanged: (index) => setState(() {
            _currentPageIndex = index;
          }),
          children: <Widget>[
            OnboardingPage(
                image: Image(
                    image: AssetImage(
                        'assets/images/product_images/product_image_1.jpg'),
                    width: 200),
                headline: 'Amet officia est ut esse occaecat ad culpa enim.',
                detail: 'Aute velit nostrud reprehenderit consequat do aute.'),
            OnboardingPage(
                image: Image(
                    image: AssetImage(
                        'assets/images/product_images/product_image_1.jpg'),
                    width: 200),
                headline: 'Ex laborum enim fugiat ex.',
                detail:
                    'Non aliquip est consequat occaecat reprehenderit est.'),
            OnboardingPage(
                image: Image(
                    image: AssetImage(
                        'assets/images/product_images/product_image_1.jpg'),
                    width: 200),
                headline:
                    'Nulla culpa velit laboris ea tempor quis id sunt ad.',
                detail:
                    'Veniam duis esse incididunt proident voluptate commodo.'),
            GetStartedPage(
              onCreateAccountButtonPressed: widget.onCreateAccountButtonPressed,
              onSignInButtonPressed: widget.onSignInButtonPressed,
            )
          ],
        )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: PageIndicator(currentPageIndex: _currentPageIndex, pageQty: 4),
        )
      ]),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
