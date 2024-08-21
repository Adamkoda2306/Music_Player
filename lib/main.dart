import 'package:flutter/material.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:music_player/pages/HomePage.dart';
import 'package:music_player/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => PlaylistProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Homepage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
