import 'package:believer/controller/app_localization.dart';
import 'package:believer/controller/my_app.dart';
import 'package:believer/cubit/user_cubit.dart';
import 'package:believer/views/screens/user_screen.dart';
import 'package:believer/views/widgets/icon_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      child: SafeArea(
        child: Container(
          height: 65,
          decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    blurRadius: 0.5, offset: Offset(0, -1), color: Colors.grey)
              ],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    4,
                    (index) => InkWell(
                          onTap: () {
                            userCubit.changeIndex(index);
                          },
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Stack(
                                    children: [
                                      AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(200),
                                              bottomRight: Radius.circular(200),
                                            ),
                                            color: primaryColor),
                                        width: 20,
                                        height: userCubit.selectedIndex == index
                                            ? 10
                                            : 0,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    staticData.bottomBar[index].values.first,
                                    color: userCubit.selectedIndex == index
                                        ? Colors.orangeAccent
                                        : Colors.black,
                                  ),
                                  Text(
                                    staticData.bottomBar[index].keys.first
                                        .toString()
                                        .tr(context),
                                    style: TextStyle(
                                      color: userCubit.selectedIndex == index
                                          ? Colors.orangeAccent
                                          : Colors.black,
                                    ),
                                  )
                                ],
                              ),
                              if (index == 2 && userCubit.cartList.isNotEmpty)
                                Positioned(
                                  right: -1,
                                  top: 11,
                                  child: BadgeIcon(
                                    badgeText:
                                        userCubit.totalCartCount().toString(),
                                  ),
                                )
                            ],
                          ),
                        )),
              );
            },
          ),
        ),
      ),
    );
  }
}
