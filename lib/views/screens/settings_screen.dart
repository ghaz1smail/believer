import 'package:believer/controller/app_localization.dart';
import 'package:believer/controller/my_app.dart';
import 'package:believer/cubit/auth_cubit.dart';
import 'package:believer/views/screens/splash_screen.dart';
import 'package:believer/views/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(
        action: {},
        title: 'Settings',
      ),
      body: Column(
        children: [
          if (auth.userData.uid.isNotEmpty)
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return SwitchListTile(
                  value: auth.notification,
                  activeColor: primaryColor,
                  title: Text(
                    'notifications'.tr(context),
                  ),
                  onChanged: (value) {
                    HapticFeedback.lightImpact();
                    auth.changeNotification(value);
                  },
                  secondary: const Icon(Icons.notifications),
                );
              },
            ),
          if (auth.userData.uid.isNotEmpty)
            if (firebaseAuth.currentUser?.providerData.first.providerId ==
                'password')
              ListTile(
                title: Text(
                  'changeEmail'.tr(context),
                ),
                onTap: () {},
                leading: const Icon(Icons.email),
              ),
          if (auth.userData.uid.isNotEmpty)
            if (firebaseAuth.currentUser?.providerData.first.providerId ==
                'password')
              ListTile(
                title: Text(
                  'changePass'.tr(context),
                ),
                onTap: () {},
                leading: const Icon(Icons.password),
              ),
          ListTile(
            title: Text(
              'changeLang'.tr(context),
            ),
            onTap: () {
              if (locale.locale == 'ar') {
                locale.changeLanguage('en');
              } else {
                locale.changeLanguage('ar');
              }
            },
            leading: const Icon(Icons.language),
          ),
          if (auth.userData.uid.isNotEmpty)
            ListTile(
              title: Text(
                'deleteAccount'.tr(context),
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () {},
              leading: const Icon(
                Icons.person_remove,
                color: Colors.red,
              ),
            ),
        ],
      ),
    );
  }
}
