import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gshala/getxnetworkmanager.dart';
import 'package:gshala/localization_service.dart';
import 'package:gshala/networkbindings.dart';
import 'package:gshala/screens/homepage.dart';
import 'package:gshala/screens/offlinemainpage.dart';
import 'package:gshala/screens/offlinevideoslist.dart';
import 'package:gshala/screens/profileselectionpage.dart';
import 'package:gshala/screens/viewvideopage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    final GetXNetworkManager _networkManager = Get.put(GetXNetworkManager());
    return GetMaterialApp(
      initialBinding: NetWorkBindings(),
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
      translations: LocalizationService(),
      locale: LocalizationService.locale,
      fallbackLocale: LocalizationService.fallbackLocale,
      home: HomePage(),
      // Obx(() {
      //   return _networkManager.connectionType.value == 0
      //       ? OfflineMainPage()
      //       : HomePage();
      // }),
      routes: {
        '/offlinemainpage': (context) => OfflineMainPage(),
        '/offlinevideoslist': (context) => OfflineVideosList(),
        '/viewvideopage': (context) => ViewVideoPage(),
        'profilepage': (context) => ProfileSelectionPage(),
      },
    );
  }
}
