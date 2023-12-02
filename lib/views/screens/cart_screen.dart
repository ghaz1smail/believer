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
  bool showBottom = true, end = true;
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
                : AnimatedContainer(
                    width: dWidth,
                    onEnd: () {
                      if (showBottom) {
                        setState(() {
                          end = true;
                        });
                      } else {
                        setState(() {
                          end = false;
                        });
                      }
                    },
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    duration: const Duration(milliseconds: 250),
                    height: showBottom ? 160 : 85,
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black38,
                              blurRadius: 0.5,
                              spreadRadius: 0.5)
                        ],
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                setState(() {
                                  showBottom = !showBottom;
                                });
                              },
                              child: Icon(showBottom
                                  ? Icons.expand_more
                                  : Icons.expand_less)),
                          if (showBottom && end)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    'Subtotal (${userCubit.totalCartCount()} items)'),
                                Text(
                                  'AED ${userCubit.totalCartPrice().toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          if (showBottom && end)
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Delivery Fee'),
                                Text(
                                  'AED 25',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          if (showBottom && end)
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Discount'),
                                Text(
                                  'AED 10',
                                  style: TextStyle(fontWeight: FontWeight.w600),
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
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              color: primaryColor,
                              textColor: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      'AED ${(userCubit.totalCartPrice() + 25.0 - 10).toStringAsFixed(2)}'),
                                  const Text('CHECKOUT'),
                                ],
                              ),
                            ),
                          )
                        ]),
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
                            Image.asset('assets/images/empty_cart.png'),
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
                            return Dismissible(
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (direction) async {
                                staticWidgets.showBottom(
                                    context,
                                    BottomSheetRemoveCart(
                                      index: index,
                                    ),
                                    0.4,
                                    0.5);
                                return false;
                              },
                              onDismissed: (direction) async {},
                              key: UniqueKey(),
                              background: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                ),
                                padding: const EdgeInsets.only(right: 20),
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red.shade900,
                                ),
                              ),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    child: CachedNetworkImage(
                                      imageUrl: cart.productData!.media![0],
                                      width: 75,
                                      height: 75,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    cart.productData!.titleEn,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  visualDensity:
                                      const VisualDensity(vertical: 4),
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
                              ),
                            );
                          }),
                )));
      },
    );
  }
}
