import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'modules/onbording.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false ,
      title: "Banking App",
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home:const Onbording()
    );
  }
}
