import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gshala/screens/homepage.dart';
import 'package:gshala/screens/offlinevideoslist.dart';
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
        fontFamily: GoogleFonts.poppins().fontFamily,
        backgroundColor: Color(0xff1B52CC),
      ),
      debugShowCheckedModeBanner: false,
      home: OfflineVideosList(),
      routes: {
        '/offlinevideoslist': (context) => OfflineVideosList(),
        '/viewvideopage': (context) => ViewVideoPage(),
      },
    );
  }
}
