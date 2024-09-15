import 'package:flutter/material.dart';

final colorsurface = Colors.grey.shade100;

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade100,
    primary: Colors.grey.shade400,
    secondary: Colors.grey.shade500,
    inversePrimary: Colors.black,
  ),

  appBarTheme: AppBarTheme(
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    backgroundColor: colorsurface,
  ),

  iconTheme: const IconThemeData(
    color: Colors.black,
  ),

  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      //fontFamily: 'Audiowide',
    ),
    bodyMedium: TextStyle(
      // fontFamily: 'Audiowide',
    ),
    displayLarge: TextStyle(
      // fontFamily: 'Audiowide',
      // fontSize: 96.0,
      // fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      // fontFamily: 'Audiowide',
      // fontSize: 60.0,
      // fontWeight: FontWeight.bold,
    ),
    displaySmall: TextStyle(
      // fontFamily: 'Audiowide',
      // fontSize: 48.0,
      // fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      // fontFamily: 'Audiowide',
      // fontSize: 34.0,
      // fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      // fontFamily: 'Audiowide',
      // fontSize: 24.0,
      // fontWeight: FontWeight.bold,
    ),
    titleLarge: TextStyle(
      // fontFamily: 'Audiowide',
      // fontSize: 20.0,
      // fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      // fontFamily: 'Audiowide',
      // fontSize: 16.0,
      // fontWeight: FontWeight.normal,
    ),
    titleSmall: TextStyle(
      // fontFamily: 'Audiowide',
      // fontSize: 14.0,
      // fontWeight: FontWeight.normal,
    ),
    bodySmall: TextStyle(
      // fontFamily: 'Audiowide',
      // fontSize: 12.0,
    ),
    labelLarge: TextStyle(
      // fontFamily: 'Audiowide',
      // fontSize: 14.0,
      // fontWeight: FontWeight.bold,
    ),
    labelSmall: TextStyle(
      // fontFamily: 'Audiowide',
      // fontSize: 10.0,
    ),

  ),

);
