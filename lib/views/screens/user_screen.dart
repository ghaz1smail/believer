import 'package:believer/cubit/user_cubit.dart';
import 'package:believer/views/widgets/home.dart';
import 'package:believer/views/widgets/profile.dart';
import 'package:believer/views/widgets/search.dart';
import 'package:believer/views/widgets/user_bottom_bar.dart';
import 'package:believer/views/widgets/wish_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

UserCubit userCubit = UserCubit();

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        userCubit = BlocProvider.of<UserCubit>(context);
        return Scaffold(
            backgroundColor: Colors.white,
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
