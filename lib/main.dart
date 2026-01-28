import 'package:arise_and_shine/controllers/home_controller.dart';
import 'package:arise_and_shine/firebase_options.dart';
import 'package:arise_and_shine/screens/onbording/splash_screen.dart';
import 'package:arise_and_shine/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'translations/translations.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppTranslations.loadTranslations();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          translations: AppTranslations(),
          locale: const Locale('en'),
          fallbackLocale: const Locale('en'),
          title: 'Arise and Shine',
          theme: AppTheme.lightTheme(context),
          themeMode: homeController.isDarkMode.value
              ? ThemeMode.dark
              : ThemeMode.light,
          darkTheme: AppTheme.darkTheme(context),
          home: child,
        );
      },
      child: const SplashScreen(),
    );
  }
}
