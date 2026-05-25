import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'modules/onbording.dart';
import 'objectbox.g.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final store = openStore();
  Get.put(store);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Banking App",
      theme: ThemeData(textTheme: GoogleFonts.interTextTheme()),
      home: const Onbording(),
    );
  }
}
