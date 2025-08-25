import 'package:evently/Core/Assets/Images/Imagespath.dart';
import 'package:evently/Core/Service/sharedprefernced.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {



  Future<void> _navigateToOnboarding(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    if(localStorage.getBool('onboardingCompleted') == true) {
      Navigator.pushReplacementNamed(context, '/login');
    }else
    Navigator.pushReplacementNamed(context, '/onboarding');
  }
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding(context);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Image.asset(
          ImagesPath.logo
         , width: 130,
          height: 180,
        ),
      ),
    );
  }
}