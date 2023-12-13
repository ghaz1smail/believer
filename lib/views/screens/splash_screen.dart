import 'package:believer/controller/app_localization.dart';
import 'package:believer/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

AuthCubit auth = AuthCubit();

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    auth = BlocProvider.of<AuthCubit>(context);
    auth.checkUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Spacer(),
            Lottie.asset('assets/lotties/splash.json', repeat: false),
            const Spacer(),
            Text(
              'believer'.tr(context),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
