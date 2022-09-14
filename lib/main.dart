import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todo_app/db/db_helper.dart';
import 'package:todo_app/screens/animated_splash_screen.dart';
import 'package:todo_app/services/theme_services.dart';
import 'package:todo_app/utility/themes.dart';

import 'screens/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.removeAfter(nativeSplashInitialization);

  await DbHelper.initDb();
  await GetStorage.init();
  MobileAds.instance.initialize(); // for google ads
  runApp(MyApp());
  FlutterNativeSplash.remove();
}

Future nativeSplashInitialization(BuildContext? context) async {
  await Future.delayed(Duration(seconds: 1));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  var applicationName = 'Yapılacaklar Listesi';

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: applicationName,
        theme: Themes.lightMode,
        themeMode: ThemeService().theme,
        darkTheme: Themes.darkMode,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const <Locale>[
          Locale('tr', 'TR'),
          //Locale('en', 'US'),
        ],
        home: SplashScreen());
  }
}
