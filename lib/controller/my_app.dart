import 'package:believer/controller/language_controller.dart';
import 'package:believer/controller/languages.dart';
import 'package:believer/controller/static_data.dart';
import 'package:believer/controller/static_functions.dart';
import 'package:believer/controller/static_widgets.dart';
import 'package:believer/get_initial.dart';
import 'package:believer/views/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

StaticData staticData = StaticData();
StaticWidgets staticWidgets = StaticWidgets();
StaticFunctions staticFunctions = StaticFunctions();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Languages(),
      locale: Locale(Get.find<LanguageController>().getSavedLanguage()),
      debugShowCheckedModeBanner: false,
      theme: appConstant.theme,
      routes: appConstant.routes,
      home: const SplashScreen(),
    );
  }
}
