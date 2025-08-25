import 'package:evently/Core/Assets/Color/Colors.dart';
import 'package:evently/Core/Assets/Icons/iconsPath.dart';
import 'package:evently/Core/Assets/Images/Imagespath.dart';
import 'package:evently/Core/Custom/Customtextform.dart';
import 'package:evently/Core/settingProvider.dart';
import 'package:evently/Core/utils/firebase_Auth_utils.dart';
import 'package:evently/Core/utils/firebase_firestores_utils.dart';
import 'package:evently/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _namecontroller= TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
  var App = AppLocalizations.of(context)!;
  var provider = Provider.of<Settingprovider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text(App.register),
        backgroundColor: ColorsApp.primary,
      ),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: () {
            setState(() {});
          },
          
          child: ListView(
            children: [
             Image.asset(ImagesPath.logo , width: 180,height: 130,),
              const SizedBox(height: 20,),
               Customtextform(
                controller: _namecontroller,
                labelText: App.name,
                prefixIcon: Icons.person_outline,
                valitor: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10,),
               Customtextform(
                controller:_emailController ,
                labelText: App.email,
                prefixIcon: Icons.email_outlined,
                valitor: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(value)) {
                    return 'Please enter a valid Gmail address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10,),
               Customtextform(
                controller: _passwordController,
                labelText: App.password,
                prefixIcon: Icons.lock_outline,
                ispassword: true,
                valitor: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
            
               const SizedBox(height: 10,),
               Customtextform(
                valitor: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  } else if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                labelText: App.confirm_password,
                prefixIcon: Icons.lock_outline,
                ispassword: true,
              ),
              const SizedBox(height: 20,),
             
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    FirebaseAuthUtils.createUserWithEmailAndPassword(
                      email: _emailController.text, password: _passwordController.text, context: context)
                        .then((value) {
                      if (value) {
                        FirebaseFirestoreUtils.saveUsernameToFirestore(
                          uid: FirebaseAuthUtils.getCurrentUserid() ?? '',
                          username: _namecontroller.text,
                        );
                        
                        Navigator.pop(context);
                      }
                     
                    });
                  }

                  
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.blue,
                ),
                child:  Text(
                  App.signup,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20,),
               InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: RichText(
                  textAlign: TextAlign.center,
                  text:  TextSpan(
                    text: App.already_haveaccount,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    children: [
                      TextSpan(
                        text: App.login,
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                       
                         
                      ),
                    ],
          
                  ),
                ),
              ),
              const SizedBox(height: 20,),
               Row(
                                       mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () => provider.setLanguage('en'),
                              child: CircleAvatar(
                                radius: 15,
                                child:Image.asset(
                                  Iconspath.americanIcon,
                                 
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                             InkWell(
                              onTap: () => provider.setLanguage('ar'),
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
             
                
            ]
          ),
        )
      )
    );
  }
}