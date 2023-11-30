import 'package:believer/models/category_model.dart';
import 'package:believer/views/screens/admin_categories.dart';
import 'package:believer/views/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        ListTile(
          leading: const Icon(Icons.ad_units),
          title: const Text('Banners'),
          onTap: () {
            Navigator.pushNamed(context, 'adminB');
          },
        ),
        ListTile(
          leading: const Icon(Icons.category),
          title: const Text('Categories'),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminCategories(
                    category: CategoryModel(titleEn: 'Categories'),
                  ),
                ));
          },
        ),
        ListTile(
          leading: const Icon(Icons.inventory),
          title: const Text('Products'),
          onTap: () {
            Navigator.pushNamed(context, 'adminP');
          },
        ),
        ListTile(
          leading: const Icon(Icons.local_activity),
          title: const Text('Coupons'),
          onTap: () {
            Navigator.pushNamed(context, 'coupons');
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.logout,
            color: Colors.red,
          ),
          title: const Text(
            'Log Out',
            style: TextStyle(color: Colors.red),
          ),
          onTap: () {
            auth.logOut();
          },
        ),
      ],
    ));
  }
}
