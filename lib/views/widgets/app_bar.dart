import 'package:believer/views/screens/user_screen.dart';
import 'package:believer/views/widgets/icon_badge.dart';
import 'package:flutter/material.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  const AppBarCustom(
      {super.key, this.title = '', required this.action, this.loading = false});
  final String title;
  final Map action;
  final bool loading;

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      leadingWidth: 60,
      actions: [
        if (action.isNotEmpty)
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : GestureDetector(
                      onTap: () {
                        action['function']();
                      },
                      child: const Chip(
                        label: Text('Add'),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                      ),
                    )),
        if (action['icon'].toString() == 'Icons.shopping_bag')
          Container(
            width: 60,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: IconButton(
                    onPressed: () async {
                      action['function']();
                    },
                    icon: Icon(
                      action['icon'] as IconData,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
                if (userCubit.totalCartCount() > 0)
                  Positioned(
                      top: 0,
                      right: 0,
                      child: BadgeIcon(
                          badgeText: userCubit.totalCartCount().toString()))
              ],
            ),
          ),
      ],
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: InkWell(
          onTap: () async {
            Navigator.pop(context);
          },
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
