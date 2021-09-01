import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gshala/database/video_db.dart';
import 'package:gshala/getxnetworkmanager.dart';
import 'package:gshala/localization_service.dart';
import 'package:gshala/networkbindings.dart';
import 'package:gshala/screens/downloadvideopage.dart';
import 'package:gshala/screens/homepage.dart';
import 'package:gshala/screens/landingpage.dart';
import 'package:gshala/screens/nologinofflinescreen.dart';
import 'package:gshala/screens/onlineofflineselectionpage.dart';
import 'package:gshala/screens/postloginofflinemainpage.dart';
import 'package:gshala/screens/offlinevideoslist.dart';
import 'package:gshala/screens/profileselectionpage.dart';
import 'package:gshala/screens/viewvideopage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GetStorage box = new GetStorage();
  final GetXNetworkManager networkManager = Get.put(GetXNetworkManager());
  print(box.read('userName'));
  int initialRoute = await networkManager.getConnectionType();
  String pageToDisplay = '';
  if (initialRoute == 0) {
    pageToDisplay = '/nologinofflinescreen';
  } else if (initialRoute == 1) {
    pageToDisplay = '/homepage';
  } else if (initialRoute == 2) {
    pageToDisplay = '/offlinemainpage';
  } else if (initialRoute == 3) {
    pageToDisplay = '/profilepage';
  }
  final MyApp myApp = MyApp(initialRoute: pageToDisplay);

  runApp(myApp);
}

class MyApp extends StatelessWidget {
  final String? initialRoute;
  MyApp({this.initialRoute});
  @override
  Widget build(BuildContext context) {
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
      initialRoute: initialRoute,
      home: LandingPage(),
      routes: {
        '/homepage': (context) => HomePage(),
        '/nologinofflinescreen': (context) => NoLoginOfflineScreen(),
        '/offlinemainpage': (context) => PostLoginOfflineMainPage(),
        '/downloadvideopage': (context) => DownloadVideoPage(),
        '/onlineofflineselectionpage': (context) =>
            OnlineOfflineSelectionPage(),
        '/offlinevideoslist': (context) => OfflineVideosList(),
        '/viewvideopage': (context) => ViewVideoPage(),
        '/profilepage': (context) => ProfileSelectionPage(),
      },
    );
  }
}
