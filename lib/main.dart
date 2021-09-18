import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gshala/getxnetworkmanager.dart';
import 'package:gshala/localization_service.dart';
import 'package:gshala/models/0_lifecycle_model.dart';
import 'package:gshala/networkbindings.dart';
import 'package:gshala/screens/3.0_downloadvideopage.dart';
import 'package:gshala/screens/1_homepage.dart';
import 'package:gshala/screens/0_landingpage.dart';
import 'package:gshala/screens/0.1_nologinofflinescreen.dart';
import 'package:gshala/screens/2.2_offlinemainpage.dart';
import 'package:gshala/screens/2.0_profileselectionpage.dart';
import 'package:gshala/screens/4.0_viewvideopage.dart';
import 'package:gshala/screens/2.1_webviewpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  final box = new GetStorage();
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
    return LifeCycleManager(
      child: GetMaterialApp(
        initialBinding: NetWorkBindings(),
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            centerTitle: true,
            iconTheme: IconThemeData(
              color: Color(0xfffcfcfa),
            ),
          ),
          fontFamily: GoogleFonts.firaSans().fontFamily,
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
          '/viewvideopage': (context) => ViewVideoPage(),
          '/profilepage': (context) => ProfileSelectionPage(),
          '/webviewpage': (context) => WebViewPage(),
        },
      ),
    );
  }
}
