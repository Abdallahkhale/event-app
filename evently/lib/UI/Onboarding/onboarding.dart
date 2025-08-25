import 'package:evently/Core/Assets/Color/Colors.dart';
import 'package:evently/Core/Assets/Images/Imagespath.dart';
import 'package:evently/Core/Service/sharedprefernced.dart';
import 'package:evently/UI/Onboarding/customOnboarding.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  
  final PageController _pageController = PageController();
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          currentPage > 0
          ? IconButton(onPressed: (){
            if (_pageController.hasClients && _pageController.page! > 0) {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );

            }
            setState(() {}); 
          }, icon: const Icon(Icons.arrow_back_ios_new_outlined , color: ColorsApp.blue,))
          : const SizedBox(width: 12,),
           SmoothPageIndicator(
            
              count: 3,
              controller: _pageController,
              onDotClicked: (index) {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
                 setState(() {}); 
              },
              effect: const ExpandingDotsEffect(
                dotHeight: 8.0,
                dotWidth: 8.0,
                activeDotColor: ColorsApp.blue,
                dotColor: Colors.black,
              ),
            ),

          IconButton(onPressed: (){
            if (_pageController.hasClients && _pageController.page! < 2) {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } else {
              localStorage.setBool('onboardingCompleted', true);
              Navigator.pushReplacementNamed(context, '/login');
            }
          }, icon: const Icon(Icons.arrow_forward_ios_outlined , color:ColorsApp.blue,)),
        ],
      ),
    
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                  ImagesPath.logobar,
                  width: 160,
                  height: 50,
                ),
            const SizedBox(height: 5),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                children: const [
                  Customonboarding(
                    title: 'Find Events That Inspire You',
                    subtitle: "Dive into a world of events crafted to fit your unique interests. Whether you're into live music, art workshops, professional networking, or simply discovering new experiences, we have something for everyone. Our curated recommendations will help you explore, connect, and make the most of every opportunity around you.",
                    image: ImagesPath.on2,
                  ),
                 Customonboarding(
                    title: 'Effortless Event Planning',
                    subtitle: "Take the hassle out of organizing events with our all-in-one planning tools. From setting up invites and managing RSVPs to scheduling reminders and coordinating details, we’ve got you covered. Plan with ease and focus on what matters – creating an unforgettable experience for you and your guests.",
                    image: ImagesPath.on3,
                  ),
                  Customonboarding(
                    title: 'Connect with Friends & Share Moments',
                    subtitle: 'Make every event memorable by sharing the experience with others. Our platform lets you invite friends, keep everyone in the loop, and celebrate moments together. Capture and share the excitement with your network, so you can relive the highlights and cherish the memories.',
                    image: ImagesPath.on4,
                  ),
                ],  
              ),
            )
          ],
        ),
      ) ,
    );
  }
}