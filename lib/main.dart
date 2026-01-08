import 'package:flutter/material.dart';
import 'SplashScreen.dart';

void main() {
  runApp(const ABCFunLearningApp());
}

class ABCFunLearningApp extends StatelessWidget {
  const ABCFunLearningApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ABC Fun Learning',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Comic Sans MS',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.light,
        ),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}