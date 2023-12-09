import 'package:believer/controller/app_localization.dart';
import 'package:believer/cubit/user_cubit.dart';
import 'package:believer/views/screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class UserBottomBar extends StatefulWidget {
  const UserBottomBar({super.key});

  @override
  State<UserBottomBar> createState() => _UserBottomBarState();
}

class _UserBottomBarState extends State<UserBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey))),
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            return SalomonBottomBar(
              currentIndex: userCubit.selectedIndex,
              onTap: (i) {
                userCubit.changeIndex(i);
              },
              items: [
                SalomonBottomBarItem(
                  icon: const Icon(Icons.home),
                  title: Text("home".tr(context)),
                ),
                SalomonBottomBarItem(
                  icon: const Icon(Icons.search),
                  title: Text("search".tr(context)),
                ),
                SalomonBottomBarItem(
                  icon: const Icon(Icons.favorite_border),
                  title: Text("favorites".tr(context)),
                ),
                SalomonBottomBarItem(
                  icon: const Icon(Icons.person),
                  title: Text("profile".tr(context)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
