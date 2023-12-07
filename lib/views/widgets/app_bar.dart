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
      ],
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
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
