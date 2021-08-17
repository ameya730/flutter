import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gshala/screens/homepage.dart';
import 'package:gshala/screens/viewvideopage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Color(0xfffcfcfa),
          ),
        ),
        fontFamily: GoogleFonts.acme().fontFamily,
        backgroundColor: Color(0xfffcfcfa),
        primaryColor: Color(0xff3873F7),
        hintColor: Colors.grey.shade600,
        buttonColor: Color(0xff3873F7),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: {
        '/viewvideopage': (context) => ViewVideoPage(),
      },
    );
  }
}
