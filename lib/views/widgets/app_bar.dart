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
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 70,
      actions: [
        if (action.isNotEmpty)
          Container(
            width: 70,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 0.5),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100))),
                    child: InkWell(
                      onTap: () async {
                        action['function']();
                      },
                      child: Icon(
                        action['icon'] as IconData,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
          ),
      ],
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 0.5),
              borderRadius: const BorderRadius.all(Radius.circular(100))),
          child: InkWell(
            onTap: () async {
              Navigator.pop(context);
            },
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
