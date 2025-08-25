import 'dart:math';
import 'package:evently/Core/Assets/Theme/Theme.dart';
import 'package:evently/Core/settingProvider.dart';
import 'package:evently/Core/utils/Google_Auth.dart';
import 'package:evently/Core/utils/firebase_Auth_utils.dart';
import 'package:evently/Core/utils/firebase_firestores_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:evently/Core/Assets/Color/Colors.dart';
import 'package:evently/Core/Assets/Images/Imagespath.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Settingprovider>(context);
    var  App = AppLocalizations.of(context)!;
    return  Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(left :16),
        width: MediaQuery.of(context).size.width * 0.7,
        child: FloatingActionButton(
          backgroundColor: Colors.red,
          
        
          onPressed: () {
            FirebaseAuthUtils.signOut().then((value) {
              if (value) {
                Navigator.pushReplacementNamed(context, '/login');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to log out')),
                );
              }
            });
          },
          child:  Row(
        
            children: [
              Icon(Icons.login, color: Colors.white),
              SizedBox(width: 8),
              Text(App.logout, 
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontSize: 18,
              )),
         
            ],
          ),
        ),
      ),
      body: Column(
        
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(width: 25,),
                Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(80),
                      bottomRight: Radius.circular(80),
                      topRight: Radius.circular(80),
                     // topLeft: Radius.circular(80),
                    ),
                   
                    image: DecorationImage(
                      image: AssetImage(ImagesPath.profile),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 20,),
        
              Expanded(
                child:  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40,),
                      // Text(
                      //   "John Safwat",
                      //   style: TextStyle(
                      //     fontSize: 24,
                      //     color: Colors.white,
                      //     fontWeight: FontWeight.bold,
                        
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                      FutureBuilder<String?>(
                        future: FirebaseFirestoreUtils.getUsernameFromFirestore(
                          FirebaseAuthUtils.getCurrentUserid().toString()
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text(
                              'Loading...',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              'Error loading username',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                            );
                          } else if (snapshot.hasData && snapshot.data != null) {
                            return Text(
                              snapshot.data!,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                            );
                          } else {
                            return Text(
                              FirebaseAuthUtils.getUsername().toString(),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      Expanded(
                        child:  FutureBuilder<String?>(
                        future: FirebaseFirestoreUtils.getUsernameFromFirestore(
                          FirebaseAuthUtils.getCurrentUserid().toString()
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text(
                              'Loading...',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              'Error loading email',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                            );
                          } else if (snapshot.hasData && snapshot.data != null) {
                            return Text(
                              snapshot.data!,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                            );
                          } else {
                            return Text(
                              FirebaseAuthUtils.getEmail().toString(),
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
                              textAlign: TextAlign.end,
                            );
                          }
                        },
                      ),
                      ),
                    ],
                  
                 ),
              )
              ],
              
              
              ),
              
             
            ),
            const SizedBox(height: 20,),
           Padding(
              padding:  const EdgeInsets.symmetric(horizontal: 16),
              child:  Text(
                App.language,
                style:  TextStyle(
                  fontSize: 24,
                  color:provider.isdDarkMode ?Colors.white: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child:  CustomDropdown<String>(
                decoration:CustomDropdownDecoration(
                  headerStyle: const TextStyle(
                    color: ColorsApp.blue,
                    fontSize: 18,
                  ),
                  closedFillColor: Colors.transparent,
                  closedSuffixIcon: const Icon(Icons.arrow_drop_down, color: ColorsApp.blue , size: 30,),
                  closedBorder: Border.all(
                    color: ColorsApp.blue
                  ),
                ),
             items: const <String>['English','العربيه' ],
             
            initialItem: 'English',
            onChanged: (value) {
             value == 'English' ? provider.setLanguage('en') : provider.setLanguage('ar');
             },
              ),
            ),
            const SizedBox(height: 20,),
               Padding(
              padding:  EdgeInsets.symmetric(horizontal: 16),
              child:  Text(
                App.theme_mode,
                style:  TextStyle(
                  fontSize: 24,
                  color:provider.isdDarkMode ?Colors.white: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomDropdown<String>(
                decoration:CustomDropdownDecoration(
                  headerStyle: const TextStyle(
                    color: ColorsApp.blue,
                    fontSize: 18,
                  ),
                  closedFillColor: Colors.transparent,
                  closedSuffixIcon: const Icon(Icons.arrow_drop_down, color: ColorsApp.blue , size: 30,),
                  closedBorder: Border.all(
                    color: ColorsApp.blue
                  ),
                ),
                items:  <String>[App.light, App.dark],
                initialItem: App.light,
                onChanged: (value) {
                  // Handle theme change
                  if (value == App.light) {
                    provider.tosettheme(themeDataclass.lightTheme);
                  } else {
                    provider.tosettheme(themeDataclass.darkTheme);
                  }
                },
              ),
            ),
            
            
          ],
        ),
      
    );
  }
}