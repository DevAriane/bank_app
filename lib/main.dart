import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'modules/onbording.dart';
import './data/services/objectbox_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Get.putAsync<ObjectBoxService>(() async => ObjectBoxService().init());
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Banking App",
      theme: ThemeData(textTheme: GoogleFonts.interTextTheme()),
      home: const Onbording(),
    );
  }
}
