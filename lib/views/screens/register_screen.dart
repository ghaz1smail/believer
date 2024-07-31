import 'dart:io';
import 'package:believer/controller/auth_controller.dart';
import 'package:believer/controller/my_app.dart';
import 'package:believer/get_initial.dart';
import 'package:believer/views/widgets/edit_text.dart';
import 'package:believer/views/widgets/forgot_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  bool signIn = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: GetBuilder(
          init: AuthController(),
          builder: (auth) {
            signIn = _tabController.index == 0;
            return Form(
              key: auth.key,
              child: SafeArea(
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 40,
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          border: Border.symmetric(
                              horizontal: BorderSide(width: 0.25))),
                      margin: const EdgeInsets.only(bottom: 25),
                      child: TabBar(
                        onTap: (value) {
                          setState(() {});
                        },
                        controller: _tabController,
                        tabs: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'signIn'.tr,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'createAcc'.tr,
                              style: const TextStyle(color: Colors.black),
                            ),
                          )
                        ],
                        indicatorColor: appConstant.primaryColor,
                        indicatorWeight: 4,
                        indicatorSize: TabBarIndicatorSize.tab,
                      ),
                    ),
                    if (!signIn)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: EditText(
                            hint: 'Ex. Ahmad',
                            function: auth.auth,
                            controller: auth.name,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'pleaseName'.tr;
                              }
                              return null;
                            },
                            title: 'name'),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: EditText(
                          hint: 'example@gmail.com',
                          function: auth.auth,
                          controller: auth.email,
                          validator: (value) {
                            if (!value!.contains('@') && !value.contains('.')) {
                              return 'pleaseEmail'.tr;
                            }
                            return null;
                          },
                          title: 'email'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: EditText(
                          hint: '',
                          secure: true,
                          function: auth.auth,
                          controller: auth.password,
                          validator: (value) {
                            if (value!.length < 8) {
                              return 'pleasePassword'.tr;
                            }
                            return null;
                          },
                          title: 'password'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Align(
                        child: MaterialButton(
                          minWidth: Get.width,
                          height: 50,
                          onPressed: () async {
                            auth.auth(signIn);
                          },
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          color: appConstant.primaryColor,
                          child: auth.loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                              : Text(
                                  signIn ? 'signIn'.tr : 'signUp'.tr,
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                        ),
                      ),
                    ),
                    signIn
                        ? Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(bottom: 50),
                            child: TextButton(
                                style: ButtonStyle(
                                    overlayColor: WidgetStateProperty.all(
                                        Colors.red.shade50)),
                                onPressed: () {
                                  staticWidgets.showBottom(context,
                                      const BottomSheetForgot(), 0.4, 0.5);
                                },
                                child: Text(
                                  'forgot'.tr,
                                  style: TextStyle(
                                    color: appConstant.primaryColor,
                                  ),
                                )),
                          )
                        : Container(
                            margin: const EdgeInsets.only(bottom: 50, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Checkbox(
                                  shape: const CircleBorder(),
                                  value: auth.agree,
                                  onChanged: (v) {
                                    auth.agreeTerm();
                                  },
                                  activeColor: appConstant.primaryColor,
                                ),
                                Text(
                                  'agree'.tr,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                TextButton(
                                    style: ButtonStyle(
                                        overlayColor: WidgetStateProperty.all(
                                            Colors.red.shade100)),
                                    onPressed: () {
                                      staticFunctions.urlLauncher(Uri.parse(
                                          'https://sites.google.com/view/believergoods/home'));
                                    },
                                    child: Text(
                                      'term'.tr,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: appConstant.primaryColor,
                                          decoration: TextDecoration.underline),
                                    ))
                              ],
                            )),
                    if (signIn && !auth.loading)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (Platform.isIOS)
                            InkWell(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100)),
                                onTap: () {
                                  auth.appleSignIn();
                                },
                                child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(100))),
                                    child: Row(
                                      children: [
                                        Brand(
                                          Brands.apple_logo,
                                          size: 20,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text('apple'.tr)
                                      ],
                                    ))),
                          InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                              onTap: () {
                                auth.googleSignIn();
                              },
                              child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(100))),
                                  child: Row(
                                    children: [
                                      Brand(
                                        Brands.google,
                                        size: 20,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text('google'.tr)
                                    ],
                                  ))),
                        ],
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (!auth.loading)
                      Align(
                        child: InkWell(
                          onTap: () async {
                            Get.offNamed('user');
                          },
                          splashColor: Colors.red.shade100,
                          child: Text('skip'.tr,
                              style: TextStyle(
                                color: appConstant.primaryColor,
                              )),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
