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

class _RegisterScreenState extends State<RegisterScreen> {
  bool signIn = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          signIn = auth.signIn;
          return Form(
            key: auth.key,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SafeArea(
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 50, bottom: 15),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: Text(
                          signIn ? 'signIn'.tr(context) : 'signUp'.tr(context),
                          key: ValueKey<String>(signIn ? 'signIn' : 'signUp'),
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(bottom: 20),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: Text(
                          signIn
                              ? 'welcomeBack'.tr(context)
                              : 'fill'.tr(context),
                          textAlign: TextAlign.center,
                          key:
                              ValueKey<String>(signIn ? 'welcomeBack' : 'fill'),
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    if (!signIn)
                      EditText(
                          hint: 'Ex. Ghazi',
                          function: auth.auth,
                          controller: auth.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'pleaseName'.tr(context);
                            }
                            return null;
                          },
                          title: 'name'),
                    const SizedBox(
                      height: 10,
                    ),
                    EditText(
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
                    const SizedBox(
                      height: 10,
                    ),
                    EditText(
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
                    if (signIn)
                      Container(
                        margin: const EdgeInsets.only(bottom: 25),
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.amber.shade50)),
                            onPressed: () {
                              staticWidgets.showBottom(
                                  context, const BottomSheetForgot(), 0.4, 0.5);
                            },
                            child: Text(
                              'forgot'.tr(context),
                              style: TextStyle(
                                  color: primaryColor,
                                  decoration: TextDecoration.underline),
                            )),
                      ),
                    if (!signIn)
                      Container(
                          margin: const EdgeInsets.only(bottom: 25, top: 10),
                          alignment: Alignment.centerLeft,
                          child: Row(
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
                    Align(
                      child: state is LoadingState
                          ? CircularProgressIndicator(
                              color: primaryColor,
                            )
                          : MaterialButton(
                              minWidth: dWidth,
                              height: 50,
                              onPressed: () async {
                                auth.auth(context);
                              },
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))),
                              color: primaryColor,
                              child: Text(
                                signIn
                                    ? 'signIn'.tr(context)
                                    : 'signUp'.tr(context),
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                    ),
                    if (signIn)
                      Container(
                        padding: const EdgeInsets.only(top: 50, bottom: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              width: 100,
                              child: const Divider(
                                thickness: 1,
                              ),
                            ),
                            Text('or'.tr(context)),
                            Container(
                              width: 100,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: const Divider(
                                thickness: 1,
                              ),
                            )
                          ],
                        ),
                      ),
                    if (signIn)
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
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(100))),
                                  child: Logo(
                                    Logos.apple,
                                    size: 30,
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
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(100))),
                                  child: Logo(
                                    Logos.google,
                                    size: 30,
                                  ))),
                        ],
                      ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: Text(
                            signIn
                                ? 'dontHave'.tr(context)
                                : 'haveAcc'.tr(context),
                            key: ValueKey<String>(
                                signIn ? 'dontHave' : 'haveAcc'),
                            style: const TextStyle(fontWeight: FontWeight.w400),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            auth.changeStatus();
                          },
                          style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(
                                  Colors.amber.shade50)),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: Text(
                                signIn
                                    ? 'signUp'.tr(context)
                                    : 'signIn'.tr(context),
                                key: ValueKey<String>(
                                    signIn ? 'signUp' : 'signIn'),
                                style: TextStyle(
                                    color: primaryColor,
                                    decoration: TextDecoration.underline)),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      child: TextButton(
                        onPressed: () async {
                          await firebaseAuth.signInAnonymously();
                          navigatorKey.currentState
                              ?.pushReplacementNamed('user');
                        },
                        style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                Colors.amber.shade50)),
                        child: Text('skip'.tr(context),
                            key: ValueKey<String>(signIn ? 'signUp' : 'signIn'),
                            style: TextStyle(
                              color: primaryColor,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
