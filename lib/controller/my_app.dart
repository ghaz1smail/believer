import 'package:believer/controller/app_localization.dart';
import 'package:believer/controller/static_data.dart';
import 'package:believer/controller/static_functions.dart';
import 'package:believer/controller/static_widgets.dart';
import 'package:believer/cubit/auth_cubit.dart';
import 'package:believer/cubit/locale_cubit.dart';
import 'package:believer/cubit/user_cubit.dart';
import 'package:believer/views/screens/address_screen.dart';
import 'package:believer/views/screens/admin_banners.dart';
import 'package:believer/views/screens/admin_coupons.dart';
import 'package:believer/views/screens/admin_products.dart';
import 'package:believer/views/screens/admin_screen.dart';
import 'package:believer/views/screens/categories_screen.dart';
import 'package:believer/views/screens/checkout_screen.dart';
import 'package:believer/views/screens/forgot_password.dart';
import 'package:believer/views/screens/notification_screen.dart';
import 'package:believer/views/screens/register_screen.dart';
import 'package:believer/views/screens/splash_screen.dart';
import 'package:believer/views/screens/user_screen.dart';
import 'package:believer/views/screens/cart_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

LocaleCubit locale = LocaleCubit();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;

final physical =
    WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
final devicePixelRatio =
    WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
final double dHeight = physical.height / devicePixelRatio;
final double dWidth = physical.width / devicePixelRatio;

StaticData staticData = StaticData();
StaticWidgets staticWidgets = StaticWidgets();
StaticFunctions staticFunctions = StaticFunctions();

Color primaryColor = const Color(0xffEE4439);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LocaleCubit()..getSavedLanguage(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => UserCubit(),
        ),
      ],
      child: BlocBuilder<LocaleCubit, ChangeLocaleState>(
        builder: (context, state) {
          locale = BlocProvider.of<LocaleCubit>(context);
          return MaterialApp(
            locale: state.locale,
            navigatorKey: navigatorKey,
            scaffoldMessengerKey: snackbarKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primaryColor: primaryColor,
                appBarTheme: AppBarTheme(backgroundColor: primaryColor)),
            supportedLocales: const [Locale('en'), Locale('ar')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            localeResolutionCallback: (deviceLocale, supportedLocales) {
              for (var locale in supportedLocales) {
                if (deviceLocale != null &&
                    deviceLocale.languageCode == locale.languageCode) {
                  return deviceLocale;
                }
              }

              return supportedLocales.first;
            },
            routes: {
              'register': (context) => const RegisterScreen(),
              'user': (context) => const UserScreen(),
              'cart': (context) => const CartScreen(),
              'categories': (context) => const CategoriesScreen(),
              'admin': (context) => const AdminScreen(),
              'adminP': (context) => const AdminProducts(),
              'adminB': (context) => const AdminBanners(),
              'address': (context) => const AddressScreen(),
              'coupons': (context) => const AdminCoupons(),
              'checkout': (context) => const CheckoutScreen(),
              'notification': (context) => const NotificationScreen(),
              'forgot': (context) => const ForgotPasswordScreen()
            },
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
