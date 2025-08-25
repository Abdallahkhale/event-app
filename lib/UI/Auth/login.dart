import 'dart:math';
import 'package:evently/Core/settingProvider.dart';
import 'package:evently/Core/utils/Google_Auth.dart';
import 'package:evently/Core/utils/firebase_Auth_utils.dart';

import 'package:evently/Core/Assets/Color/Colors.dart';
import 'package:evently/Core/Assets/Icons/iconsPath.dart';
import 'package:evently/Core/Assets/Images/Imagespath.dart';
import 'package:evently/Core/Custom/Customtextform.dart';
import 'package:evently/gen_l10n/app_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
  var provider = Provider.of<Settingprovider>(context);
  var App = AppLocalizations.of(context)!;
    return Scaffold(
           resizeToAvoidBottomInset: false,

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
           Image.asset(ImagesPath.logo , width: 180,height: 130,),
            const SizedBox(height: 20,),
             Customtextform(
              controller: _emailController,
              labelText: App.email,
              prefixIcon: Icons.email_outlined,
            ),
            const SizedBox(height: 10,),
             Customtextform(
              controller: _passwordController,
              labelText: App.password,
              prefixIcon: Icons.lock_outline,
              ispassword: true,
            ),
            const SizedBox(height: 20,),
          
           InkWell(
          onTap: () async {
           // Show loading indicator or disable button to prevent multiple taps
            bool success = await FirebaseAuthUtils.forgetpassword(
           email: _emailController.text,
           context: context,
            );
    
          // Optionally, you can add additional logic based on success/failure
            if (success) {
           // Password reset email sent successfully
            print('Password reset email sent');
             } else {
              // Handle failure if needed
             print('Failed to send password reset email');
           }
          },
          child: Text(
           App.forgotPassword, // Make sure you have this localization key
          // or use a hardcoded string like "Forgot Password?"
            style: const TextStyle(color: Colors.blue, fontSize: 16),
            textAlign: TextAlign.right,
          ),
              ),
           
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                FirebaseAuthUtils.signInWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text,
                ).then((value) {
                  if (value) {
                    Navigator.pushNamed(context, '/homescreen');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Login failed. Please try again.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.blue,
              ),
              child:  Text(
                App.login,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20,),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: RichText(
                textAlign: TextAlign.center,
                text:  TextSpan(
                  text: App.dont_have_account,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(
                      text: App.createAccount,
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                     
                       
                    ),
                  ],

                ),
              ),
            ),
            const SizedBox(height: 20,),
            const Text(
              '________________ Or ________________',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 20,),
           ElevatedButton(onPressed: (){

            FirebaseAuthUtils.signInWithGoogle().then((value) {
              if (value) {
                Navigator.pushNamed(context, '/homescreen');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Google Sign-In failed. Please try again.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            });
           }, 
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: ColorsApp.primary,
              side: BorderSide(color: Colors.blue, width: 1.5),
            ),
           child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Iconspath.googleIcon, width: 24, height: 24),
                const SizedBox(width: 10),
                 Text(App.login_google, style: TextStyle(fontSize: 16 , color: ColorsApp.blue)),
              ],

           )
           
           )
           ,
            const SizedBox(height: 20,),
                      Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              provider.setLanguage('en');
                            },
                            child: CircleAvatar(
                              
                              radius: 15,
                              child:Image.asset(
                                Iconspath.americanIcon,
                               
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                           InkWell(
                            onTap: () {
                              provider.setLanguage('ar');},
                             child: CircleAvatar(
                              radius: 15,
                              child:Image.asset(
                                Iconspath.egyptIcon,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                               
                              ),
                                                       ),
                           ),
                        ],
                                           ),
                   
                
           
           

          ],
        ),
      ),
    );
  }
}