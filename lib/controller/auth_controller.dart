import 'package:believer/controller/user_controller.dart';
import 'package:believer/get_initial.dart';
import 'package:believer/models/app_data_model.dart';
import 'package:believer/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthController extends GetxController {
  AppDataModel? appData;
  GlobalKey<FormState> key = GlobalKey();
  final _googleSignIn = GoogleSignIn();
  AuthorizationCredentialAppleID? appleCredential;
  TextEditingController email = TextEditingController(),
      password = TextEditingController(),
      name = TextEditingController();
  UserModel userData = UserModel();
  bool agree = false, notification = false, loading = false;

  changeOrders() {
    appData!.orders = !appData!.orders;
    firestore
        .collection('appInfo')
        .doc('0')
        .update({'orders': appData!.orders});
    update();
  }

  changePaymobs(x) {
    appData!.paymobs!.firstWhere((w) => w.id == x).status =
        !appData!.paymobs!.firstWhere((w) => w.id == x).status;

    firestore.collection('appInfo').doc('0').update({
      'paymobs': appData!.paymobs!
          .map((m) => {
                'id': m.id,
                'username': m.username,
                'status': m.status,
                'name': m.name
              })
          .toList()
    });
    update();
  }

  changeNotification(x) async {
    notification = x;
    getStorage.write('notification', x);
    if (x) {
      requestPermission();
    } else {
      firebaseMessaging.deleteToken();
    }
    update();
  }

  requestPermission() async {
    notification = getStorage.read('notification') ?? true;

    await firebaseMessaging.requestPermission(
        alert: true, badge: true, sound: true);

    if (notification) {
      firebaseMessaging.getToken().then((value) {
        firestore
            .collection('users')
            .doc(firebaseAuth.currentUser!.uid)
            .update({
          'token': value,
        });
      });
    }
  }

  agreeTerm() {
    agree = !agree;
    update();
  }

  logOut() async {
    Get.find<UserController>().selectedIndex = 0;
    _googleSignIn.signOut();
    userData = UserModel();
    await firebaseAuth.signOut();
    Get.offNamed('register');
  }

  getAppInfo() async {
    String v = '0';
    await firestore.collection('appInfo').doc('0').get().then((value) async {
      appData = AppDataModel.fromJson(value.data() as Map);
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      v = packageInfo.version;
    }).onError((e, e1) {
      Get.offNamed('updated');
    });

    if (!appData!.server) {
      Get.offNamed('updated');
      return;
    }

    if (GetPlatform.isIOS) {
      if (v != appData!.ios) {
        Get.offNamed('updated');
        return;
      }
    } else {
      if (v != appData!.android) {
        Get.offNamed('updated');
        return;
      }
    }
  }

  checkUser() async {
    await getAppInfo();
    if (firebaseAuth.currentUser != null) {
      if (firebaseAuth.currentUser!.uid == appConstant.adminUid) {
        await Future.delayed(const Duration(seconds: 3));
      } else {
        final stopwatch = Stopwatch()..start();
        await getUserData();
        stopwatch.stop();
        if (stopwatch.elapsed.inSeconds < 3) {
          await Future.delayed(
              Duration(seconds: 3 - stopwatch.elapsed.inSeconds));
        }
      }
    } else {
      await Future.delayed(const Duration(seconds: 3));
    }
    navigator();
  }

  getUserData() async {
    if (firebaseAuth.currentUser!.uid != appConstant.adminUid) {
      try {
        await firestore
            .collection('users')
            .doc(firebaseAuth.currentUser!.uid)
            .get()
            .then((value) {
          userData = UserModel.fromJson(value.data() as Map);
        });
      } catch (e) {
        Fluttertoast.showToast(msg: 'error');
      }
    }
  }

  deleteAccount() async {
    logOut();
    await firebaseAuth.currentUser!.delete();
  }

  navigator() async {
    if (firebaseAuth.currentUser?.uid == appConstant.adminUid) {
      Get.offNamed('admin');
    } else {
      if (userData.uid.isEmpty) {
        Get.offNamed('register');
      } else {
        requestPermission();
        Get.offNamed('user');
      }
    }
  }

  Future<void> appleSignIn() async {
    HapticFeedback.lightImpact();
    loading = true;
    update();
    try {
      appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential!.identityToken,
      );

      await firebaseAuth.signInWithCredential(oauthCredential);

      await createUser(
          '${appleCredential!.givenName} ${appleCredential!.familyName}',
          '',
          appleCredential!.email.toString(),
          true);

      await navigator();
    } catch (e) {
      loading = false;
      update();
      Fluttertoast.showToast(msg: e.toString());
    }
    loading = false;
    update();
  }

  Future<void> googleSignIn() async {
    HapticFeedback.lightImpact();
    loading = true;
    update();
    try {
      GoogleSignInAccount? googleSignInAccount;

      googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount == null) {
        loading = false;
        update();
        return;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      await firebaseAuth.signInWithCredential(credential);
      await createUser(googleSignInAccount.displayName.toString(),
          googleSignInAccount.photoUrl ?? '', googleSignInAccount.email, true);
      await navigator();
    } catch (e) {
      loading = false;
      update();
      Fluttertoast.showToast(msg: e.toString());
    }

    loading = false;
    update();
  }

  Future<void> createUser(
    String name,
    String photo,
    String email,
    bool check,
  ) async {
    Map<String, dynamic> data = {
      'uid': firebaseAuth.currentUser!.uid,
      'pic': photo,
      'verified': false,
      'blocked': false,
      'link': '',
      'timestamp': Timestamp.now(),
      'birth': Timestamp.now(),
      'phone': '',
      'coins': 0,
      'wallet': [],
      'email': email.trim(),
      'name': name.trim(),
      'address': [],
      'gender': '',
    };

    if (check) {
      await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .get()
          .then((value) async {
        if (!value.exists) {
          firestore
              .collection('users')
              .doc(firebaseAuth.currentUser!.uid)
              .set(data);
          userData = UserModel.fromJson(data);
        } else {
          await getUserData();
        }
      });
    } else {
      firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .set(data);
      userData = UserModel.fromJson(data);
    }
  }

  auth(signIn) async {
    if (!key.currentState!.validate()) {
      return;
    }
    loading = true;
    update();
    try {
      if (signIn) {
        await signInAuth();
      } else {
        await signUp();
      }
    } on FirebaseAuthException catch (e) {
      loading = false;
      update();
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: e.code.tr);
      }
      Fluttertoast.showToast(msg: 'invalidCredentials'.tr);
    }
    loading = false;
    update();
  }

  Future<void> signUp() async {
    if (agree) {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email.text.trim(), password: password.text);
      await createUser(name.text, '', email.text.trim(), false);
      navigator();
      email.clear();
      name.clear();
      password.clear();
    } else {
      Get.showSnackbar(const GetSnackBar(
        maxWidth: 300,
        borderRadius: 10,
        messageText: Center(
            child: Text(
          'Please read the Terms & Conditions and agree with it',
          style: TextStyle(fontSize: 18),
        )),
      ));
    }
  }

  Future<void> signInAuth() async {
    await firebaseAuth.signInWithEmailAndPassword(
        email: email.text.trim(), password: password.text);
    await getUserData();
    await navigator();
    email.clear();
    name.clear();
    password.clear();
  }
}
