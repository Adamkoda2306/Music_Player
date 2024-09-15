import 'package:flutter/material.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:music_player/pages/homepage.dart';
import 'package:music_player/themes/darkmode.dart';
import 'package:music_player/themes/lightmode.dart';
import 'package:music_player/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PlaylistProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      home: const Homepage(),
      themeMode: themeProvider.themeMode, // Use ThemeMode for switching
      theme: lightMode,                  // Light theme data
      darkTheme: darkMode,               // Dark theme data
    );
  }
}
