import 'package:believer/views/screens/address_screen.dart';
import 'package:believer/views/screens/admin_banners.dart';
import 'package:believer/views/screens/admin_coupons.dart';
import 'package:believer/views/screens/admin_orders.dart';
import 'package:believer/views/screens/admin_products.dart';
import 'package:believer/views/screens/admin_reviews.dart';
import 'package:believer/views/screens/admin_screen.dart';
import 'package:believer/views/screens/cart_screen.dart';
import 'package:believer/views/screens/categories_screen.dart';
import 'package:believer/views/screens/checkout_screen.dart';
import 'package:believer/views/screens/delete_account_screen.dart';
import 'package:believer/views/screens/notification_screen.dart';
import 'package:believer/views/screens/orders_screen.dart';
import 'package:believer/views/screens/payment_screen.dart';
import 'package:believer/views/screens/register_screen.dart';
import 'package:believer/views/screens/settings_screen.dart';
import 'package:believer/views/screens/user_screen.dart';
import 'package:flutter/material.dart';

class AppConstant {
  String adminUid = 'Ms4bgI9hdCUfLQF9Bf52lXAb0P43';

  final RegExp isArabic =
          RegExp(r'[\u0600-\u06FF\u0750-\u077F\uFB50-\uFDFF\uFE70-\uFEFF]'),
      userNameCode = RegExp(r'^(?=.*[a-zA-Z])[a-zA-Z0-9_]{3,20}$');

  Color primaryColor = const Color(0xffEE4439);

  List<BoxShadow> shadow = [
    const BoxShadow(
      color: Colors.black12,
      spreadRadius: 0.1,
      blurRadius: 5,
    ),
  ];

  Map<String, Widget Function(BuildContext)> routes = {
    'delete': (context) => const DeleteAccountScreen(),
    'register': (context) => const RegisterScreen(),
    'user': (context) => const UserScreen(),
    'payment': (context) => const PaymentScreen(),
    'orders': (context) => const OrdersScreen(),
    'categories': (context) => const CategoriesScreen(),
    'cart': (context) => const CartScreen(),
    'settings': (context) => const SettingsScreen(),
    'admin': (context) => const AdminScreen(),
    'adminOrders': (context) => const AdminOrders(),
    'adminReviews': (context) => const AdminReviews(),
    'adminP': (context) => const AdminProducts(),
    'adminB': (context) => const AdminBanners(),
    'address': (context) => const AddressScreen(),
    'coupons': (context) => const AdminCoupons(),
    'checkout': (context) => const CheckoutScreen(),
    'notification': (context) => const NotificationScreen(),
  };

  ThemeData theme = ThemeData(
      useMaterial3: false,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: const Color(0xffEE4439),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xffEE4439),
      ),
      primarySwatch: Colors.purple,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ));
}
