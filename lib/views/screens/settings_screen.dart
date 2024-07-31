import 'package:believer/controller/auth_controller.dart';
import 'package:believer/controller/language_controller.dart';
import 'package:believer/controller/my_app.dart';
import 'package:believer/get_initial.dart';
import 'package:believer/views/widgets/app_bar.dart';
import 'package:believer/views/widgets/delete_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        action: const {},
        title: 'settings'.tr,
      ),
      body: Column(
        children: [
          if (Get.find<AuthController>().userData.uid.isNotEmpty)
            GetBuilder(
              init: AuthController(),
              builder: (auth) {
                return SwitchListTile(
                  value: auth.notification,
                  activeColor: appConstant.primaryColor,
                  title: Text(
                    'notifications'.tr,
                  ),
                  onChanged: (value) {
                    HapticFeedback.lightImpact();
                    auth.changeNotification(value);
                  },
                  secondary: const Icon(Icons.notifications),
                );
              },
            ),
          ListTile(
            title: Text(
              'changeLang'.tr,
            ),
            onTap: () {
              if (Get.locale!.languageCode == 'ar') {
                Get.find<LanguageController>().changeLanguage('en');
              } else {
                Get.find<LanguageController>().changeLanguage('ar');
              }
            },
            leading: const Icon(Icons.language),
          ),
          if (Get.find<AuthController>().userData.uid.isNotEmpty)
            ListTile(
              title: Text(
                'deleteAccount'.tr,
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () {
                staticWidgets.showBottom(
                    context, const BottomSheetDeleteAccount(), 0.4, 0.5);
              },
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
