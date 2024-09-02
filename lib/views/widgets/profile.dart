import 'package:believer/controller/auth_controller.dart';
import 'package:believer/controller/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AuthController(),
      builder: (auth) {
        return Container(
          width: Get.width,
          height: Get.height,
          color: Colors.white,
          child: Column(
            children: [
              if (auth.userData.uid.isNotEmpty)
                ListTile(
                  title: Text(
                    'myOrders'.tr,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, 'orders');
                  },
                  leading: const Icon(OctIcons.paste),
                ),
              if (auth.userData.uid.isNotEmpty)
                ListTile(
                  title: Text(
                    'manageAdd'.tr,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, 'address');
                  },
                  leading: const Icon(FontAwesome.map_location_solid),
                ),
              // if (auth.userData.uid.isNotEmpty)
              //   ListTile(
              //     title: Text(
              //       'paymentMethod'.tr,
              //     ),
              //     onTap: () {
              //       Navigator.pushNamed(context, 'payment');
              //     },
              //     leading: const Icon(FontAwesome.wallet_solid),
              //   ),
              ListTile(
                title: Text(
                  'settings'.tr,
                ),
                onTap: () {
                  Navigator.pushNamed(context, 'settings');
                },
                leading: const Icon(EvaIcons.settings),
              ),
              ListTile(
                title: Text(
                  'help'.tr,
                ),
                onTap: () {
                  HapticFeedback.lightImpact();
                  var url = Uri(
                    scheme: 'mailto',
                    path: 'comma0tech@gmail.com',
                    query: 'subject=Help',
                  );
                  staticFunctions.urlLauncher(url);
                },
                leading: const Icon(
                  EvaIcons.question_mark_circle,
                ),
              ),
              ListTile(
                title: Text(
                  'contactUs'.tr,
                ),
                onTap: () {
                  staticFunctions.urlLauncher(Uri.parse('tel:+1234567890'));
                },
                leading: const Icon(
                  Icons.quick_contacts_mail,
                ),
              ),
              ListTile(
                leading: Icon(
                  auth.userData.uid.isNotEmpty
                      ? EvaIcons.log_out
                      : EvaIcons.log_in,
                  color: Colors.red,
                ),
                title: Text(
                  auth.userData.uid.isNotEmpty ? 'logOut'.tr : 'signIn'.tr,
                  style: const TextStyle(color: Colors.red),
                ),
                onTap: () {
                  auth.logOut();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
