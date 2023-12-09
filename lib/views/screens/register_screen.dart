import 'package:believer/controller/app_localization.dart';
import 'package:believer/controller/my_app.dart';
import 'package:believer/cubit/auth_cubit.dart';
import 'package:believer/views/screens/splash_screen.dart';
import 'package:believer/views/widgets/edit_text.dart';
import 'package:believer/views/widgets/forgot_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
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
                              'signIn'.tr(context),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'createAcc'.tr(context),
                              style: const TextStyle(color: Colors.black),
                            ),
                          )
                        ],
                        indicatorColor: primaryColor,
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
                                return 'pleaseName'.tr(context);
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
                              return 'pleaseEmail'.tr(context);
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
                              return 'pleasePassword'.tr(context);
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
                          minWidth: dWidth,
                          height: 50,
                          onPressed: () async {
                            auth.auth(context, signIn);
                          },
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          color: primaryColor,
                          child: state is LoadingState
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                              : Text(
                                  signIn
                                      ? 'signIn'.tr(context)
                                      : 'signUp'.tr(context),
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
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.red.shade50)),
                                onPressed: () {
                                  staticWidgets.showBottom(context,
                                      const BottomSheetForgot(), 0.4, 0.5);
                                },
                                child: Text(
                                  'forgot'.tr(context),
                                  style: TextStyle(
                                    color: primaryColor,
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
                                  activeColor: primaryColor,
                                ),
                                Text(
                                  'agree'.tr(context),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                TextButton(
                                    style: ButtonStyle(
                                        overlayColor: MaterialStateProperty.all(
                                            Colors.red.shade100)),
                                    onPressed: () {},
                                    child: Text(
                                      'term'.tr(context),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: primaryColor,
                                          decoration: TextDecoration.underline),
                                    ))
                              ],
                            )),
                    if (signIn && state is! LoadingState)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
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
                                      Logo(
                                        Logos.apple,
                                        size: 20,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text('apple'.tr(context))
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
                                      Logo(
                                        Logos.google,
                                        size: 20,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text('google'.tr(context))
                                    ],
                                  ))),
                        ],
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (state is! LoadingState)
                      Align(
                        child: InkWell(
                          onTap: () async {
                            await firebaseAuth.signInAnonymously();
                            navigatorKey.currentState
                                ?.pushReplacementNamed('user');
                          },
                          splashColor: Colors.red.shade100,
                          child: Text('skip'.tr(context),
                              style: TextStyle(
                                color: primaryColor,
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
