import 'package:evently/Core/Assets/Theme/Theme.dart';
import 'package:flutter/material.dart';

class Settingprovider extends ChangeNotifier {
  String language = 'en';
  ThemeData currentTheme =themeDataclass.lightTheme ;



  void setLanguage(String newLanguage) {
    if (newLanguage == language) return; 
    language = newLanguage;
    notifyListeners();
  }
  void tosettheme(ThemeData newTheme) {
    if (newTheme == currentTheme) return; 
    currentTheme = newTheme;
    notifyListeners();
  }
  get isdDarkMode => currentTheme == themeDataclass.darkTheme;

 
}