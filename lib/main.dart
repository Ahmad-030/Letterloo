import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'SplashScreen.dart';

void main() {
  runApp(const LetterLooApp());
}

class LetterLooApp extends StatelessWidget {
  const LetterLooApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LetterLoo - Learn ABC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FE),
      ),
      home: const SplashScreen(),
    );
  }
}