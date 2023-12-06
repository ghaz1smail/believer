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
          boxShadow: [
            BoxShadow(
                blurRadius: 0.5, offset: Offset(0, -1), color: Colors.grey)
          ],
        ),
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
                  title: const Text("Home"),
                ),
                SalomonBottomBarItem(
                  icon: const Icon(Icons.search),
                  title: const Text("Search"),
                ),
                SalomonBottomBarItem(
                  icon: const Icon(Icons.favorite_border),
                  title: const Text("Favorites"),
                ),
                SalomonBottomBarItem(
                  icon: const Icon(Icons.person),
                  title: const Text("Profile"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
