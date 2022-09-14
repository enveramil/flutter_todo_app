import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app/screens/home_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Lottie.asset('images/97930-loading.json'),
      backgroundColor: HexColor('008037'),
      splashIconSize: 250,
      duration: 1500,
      animationDuration: Duration(seconds: 1),
      nextScreen: HomePage(),
    );
  }
}
