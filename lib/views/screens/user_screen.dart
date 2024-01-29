import 'package:believer/controller/app_localization.dart';
import 'package:believer/cubit/user_cubit.dart';
import 'package:believer/views/screens/settings_screen.dart';
import 'package:believer/views/screens/splash_screen.dart';
import 'package:believer/views/widgets/home.dart';
import 'package:believer/views/widgets/icon_badge.dart';
import 'package:believer/views/widgets/profile.dart';
import 'package:believer/views/widgets/search.dart';
import 'package:believer/views/widgets/user_bottom_bar.dart';
import 'package:believer/views/widgets/wish_list.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

UserCubit userCubit = UserCubit();

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  fetchData() async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) async {
      if (dynamicLinkData.link.toString().contains('delete')) {
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsScreen(
                  // delete: true,
                  ),
            ));
      }
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        userCubit = BlocProvider.of<UserCubit>(context);
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              centerTitle: false,
              title: Text(
                '${'hi'.tr(context)} ${auth.userData.name}',
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              actions: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'categories');
                      },
                      icon: const Icon(
                        Icons.apps,
                        color: Colors.black,
                      )),
                ),
                const SizedBox(
                  width: 5,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      child: IconButton(
                          onPressed: () async {
                            Navigator.pushNamed(context, 'cart');
                          },
                          icon: const Icon(
                            Icons.shopping_bag,
                            color: Colors.black,
                          )),
                    ),
                    if (userCubit.totalCartCount() > 0)
                      Positioned(
                          top: 0,
                          right: 0,
                          child: BadgeIcon(
                              badgeText: userCubit.totalCartCount().toString()))
                  ],
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
            bottomNavigationBar: const UserBottomBar(),
            body: SafeArea(
              child: IndexedStack(
                index: userCubit.selectedIndex,
                children: const [Home(), Search(), WishList(), Profile()],
              ),
            ));
      },
    );
  }
}
