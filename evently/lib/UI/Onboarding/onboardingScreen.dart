import 'package:evently/Core/Assets/Color/Colors.dart';
import 'package:evently/Core/Assets/Icons/iconsPath.dart';
import 'package:evently/Core/Assets/Images/Imagespath.dart';
import 'package:flutter/material.dart';

class Onboardingscreen extends StatefulWidget {
  const Onboardingscreen({super.key});

  @override
  State<Onboardingscreen> createState() => _OnboardingscreenState();
}

class _OnboardingscreenState extends State<Onboardingscreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
    
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             Image.asset(
              ImagesPath.logobar,
              width: 160,
              height: 50,
            ),
            const SizedBox(height: 10),
             Image.asset(
              ImagesPath.on1,
              width: 360,
              height: 360,
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2.0),
              child: Text(
                'Personalize Your Experience',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: ColorsApp.blue,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2.0),
              child: Text(
                'Choose your preferred theme and language to get started with a comfortable, tailored experience that suits your style.',
                style: Theme.of(context).textTheme.bodySmall
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
        
                Text('Language', style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: ColorsApp.blue,
                  )),
                  Container(
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ColorsApp.blue, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          child:Image.asset(
                            Iconspath.americanIcon,
                           
                          ),
                        ),
                        const SizedBox(width: 10),
                         CircleAvatar(
                          radius: 15,
                          child:Image.asset(
                            Iconspath.egyptIcon,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                           
                          ),
                        ),
                      ],
                    ),
                  )
                  
              ],
              
            ),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
        
                Text('Theme', style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: ColorsApp.blue,
                  )),
                  Container(
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ColorsApp.blue, width: 1.5),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.light_mode, color: ColorsApp.blue, size: 30),
                         SizedBox(width: 10),
                       Icon(Icons.dark_mode, color: ColorsApp.blue, size: 30),
                      ],
                    ),
                  ),
                  
                  
              ],
              
            )
            ,
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/onboarding2');
              },
              
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsApp.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: 
                const Text(
                  "let's Started",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
              
              ),
            ),
          ],
        ),
      ),
    );
  }
}