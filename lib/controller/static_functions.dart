import 'dart:convert';
import 'package:believer/controller/my_app.dart';
import 'package:believer/views/screens/splash_screen.dart';
import 'package:believer/views/screens/user_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

class StaticFunctions {
  Map<String, dynamic>? paymentIntent;

  Future<void> makePayment() async {
    String price =
        userCubit.totalCartPrice().toStringAsFixed(2).replaceAll('.', '');

    paymentIntent = await createPaymentIntent(price, 'AED');

    await Stripe.instance
        .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: paymentIntent!['client_secret'],
                merchantDisplayName: auth.userData.name,
                customerId: firebaseAuth.currentUser!.uid))
        .then((value) {});

    displayPaymentSheet();
  }

  displayPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet().then((value) {
      Fluttertoast.showToast(msg: 'succsess');
    });
  }

  createPaymentIntent(String amount, String currency) async {
    var response = await Dio().post(
      'https://api.stripe.com/v1/payment_intents',
      options: Options(
        headers: {
          'Authorization':
              'Bearer sk_test_51OGoUUBkldohVpSKF8txUSH6VX0iMnSYIqiU48iSVRgLG66CaNlcRqAGxIp9hr4xmYKq4wmPGrBIa8nZzIqaD0UK00DEmyhBys',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      ),
      data: {
        'amount': amount,
        'currency': currency,
      },
    );

    return response.data;
  }

  shareData(link) {
    Share.share(link);
  }

  Future<String> generateLink(String id, String route) async {
    const apiUrl =
        'https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=AIzaSyCX3DS4w1tdKUKlDaya86rwqhwbb7cDPcA';

    final dynamicLinkData = {
      'dynamicLinkInfo': {
        'domainUriPrefix': 'https://believer.page.link',
        'link': 'https://www.believer.com?screen=/$route/$id',
        'androidInfo': {
          'androidPackageName': 'com.comma.believer',
        },
        'iosInfo': {
          'iosBundleId': 'com.comma.believer',
        },
      },
      'suffix': {
        'option': 'SHORT',
      },
    };
    var shortUrl = '';

    final respo = await Dio().post(
      apiUrl,
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: json.encode(dynamicLinkData),
    );

    shortUrl = respo.data['shortLink'];

    return shortUrl;
  }
}
