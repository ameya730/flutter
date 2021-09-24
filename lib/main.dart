import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:gshala/screens/0.1_nointernet.dart';
import 'package:gshala/screens/2.2_offlinemainpage.dart';
import 'package:gshala/screens/2.0_profileselectionpage.dart';
import 'package:gshala/screens/4.0_viewvideopage.dart';
import 'package:gshala/screens/2.1_webviewpage.dart';
import 'package:gshala/screens/forgotpassword.dart';
import 'package:gshala/screens/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays(
      [SystemUiOverlay.bottom, SystemUiOverlay.top]);

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
    pageToDisplay = '/webviewpage';
  }
  final MyApp myApp = MyApp(initialRoute: pageToDisplay);

  runApp(myApp);
}

class MyApp extends StatelessWidget {
  final String? initialRoute;
  MyApp({this.initialRoute});
  @override
  Widget build(BuildContext context) {
    return
        // FutureBuilder(
        //   future: Init.instance.initialize(),
        //   builder: (context, AsyncSnapshot snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return GetMaterialApp(
        //         home: Splash(),
        //       );
        //     } else {
        //       return
        LifeCycleManager(
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
          '/nologinofflinescreen': (context) => NoInternetPage(),
          '/offlinemainpage': (context) => PostLoginOfflineMainPage(),
          '/downloadvideopage': (context) => DownloadVideoPage(),
          '/viewvideopage': (context) => ViewVideoPage(),
          '/profilepage': (context) => ProfileSelectionPage(),
          '/webviewpage': (context) => WebViewPage(),
          '/signuppage': (context) => SignUpPage(),
          '/forgotpassword': (context) => ForgotPassword(),
        },
      ),
    );
  }
  // },
  // );
  // }
}

// class Splash extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // bool lightMode =
//     //     MediaQuery.of(context).platformBrightness == Brightness.light;
//     return Scaffold(
//       backgroundColor: Color(0xe1f5fe).withOpacity(1.0),
//       body: Center(child: Image.asset('assets/splashscreen.jpeg')),
//     );
//   }
// }

// class Init {
//   Init._();
//   static final instance = Init._();

//   Future initialize() async {
//     // This is where you can initialize the resources needed by your app while
//     // the splash screen is displayed.  Remove the following example because
//     // delaying the user experience is a bad design practice!
//     await Future.delayed(const Duration(seconds: 1));
//   }
// }
