import 'package:evently/Core/Assets/Color/Colors.dart';
import 'package:flutter/material.dart';

abstract class themeDataclass {

  
  static final ThemeData lightTheme =
 ThemeData(
        
        primaryColor: ColorsApp.primary, 
        scaffoldBackgroundColor: ColorsApp.primary,
        
        
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
          bodyMedium: TextStyle(
            color: Colors.black54,
            fontSize: 20,
            fontWeight: FontWeight.w700,

          ),
          bodySmall: TextStyle(
            color: Colors.black38,
            fontSize: 16,
          ),
        ),
      );

      static final ThemeData darkTheme =
 ThemeData(
        
        primaryColor: ColorsApp.blueDark ,
        scaffoldBackgroundColor: ColorsApp.blueDark,
        
        
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
          bodyMedium: TextStyle(
            color: Colors.black54,
            fontSize: 20,
            fontWeight: FontWeight.w700,

          ),
          bodySmall: TextStyle(
            color: Colors.black38,
            fontSize: 16,
          ),
        ),
      );
}