import 'package:flutter/material.dart';
import 'package:flutter_translate_gemini/page/page_main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.lightBlue
        ),
        useMaterial3: false,
      ),
      home: const MainPage(),
    );
  }
}