import 'package:bidlotto/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: GoogleFonts.promptTextTheme(),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red)),
      title: 'Bidlotto',
      home: const LoginPage(),
    );
  }
}
