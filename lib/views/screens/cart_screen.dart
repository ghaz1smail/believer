import 'package:believer/controller/my_app.dart';
import 'package:believer/cubit/user_cubit.dart';
import 'package:believer/models/cart_model.dart';
import 'package:believer/views/screens/user_screen.dart';
import 'package:believer/views/widgets/app_bar.dart';
import 'package:believer/views/widgets/counter.dart';
import 'package:believer/views/widgets/remove_cart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Scaffold(
            appBar: const AppBarCustom(
              action: {},
              title: 'Cart',
            ),
            bottomNavigationBar: userCubit.cartList.isEmpty
                ? null
                : SafeArea(
                    child: Container(
                      width: dWidth,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: 100,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Subtotal (${userCubit.totalCartCount()} items)',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  'AED ${userCubit.totalCartPrice().toStringAsFixed(2)}',
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: MaterialButton(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                onPressed: () {
                                  Navigator.pushNamed(context, 'checkout');
                                },
                                height: 45,
                                minWidth: dWidth,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                color: primaryColor,
                                child: const Text(
                                  'Checkout',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ]),
                    ),
                  ),
            body: Container(
                width: dWidth,
                height: dHeight,
                color: Colors.white,
                child: Center(
                  child: userCubit.cartList.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/empty_cart.png',
                              height: 150,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Your cart is empty',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                        )
                      : ListView.separated(
                          itemCount: userCubit.cartList.length,
                          separatorBuilder: (context, index) => const Divider(
                                height: 0,
                              ),
                          itemBuilder: (context, index) {
                            CartModel cart =
                                userCubit.cartList.values.toList()[index];
                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                leading: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  child: CachedNetworkImage(
                                    imageUrl: cart.productData!.media![0],
                                    width: 75,
                                    height: 75,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      cart.productData!.titleEn,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          staticWidgets.showBottom(
                                              context,
                                              BottomSheetRemoveCart(
                                                index: index,
                                              ),
                                              0.4,
                                              0.5);
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.black,
                                        ))
                                  ],
                                ),
                                visualDensity: const VisualDensity(vertical: 4),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'AED ${cart.productData!.price}',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Counter(
                                      remove: () {
                                        userCubit.addToCart(
                                            cart.productData!, -1);
                                      },
                                      add: () {
                                        userCubit.addToCart(
                                            cart.productData!, 1);
                                      },
                                      other: () {
                                        staticWidgets.showBottom(
                                            context,
                                            BottomSheetRemoveCart(
                                              index: index,
                                            ),
                                            0.4,
                                            0.5);
                                      },
                                      count: cart.count,
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                )));
      },
    );
  }
}
