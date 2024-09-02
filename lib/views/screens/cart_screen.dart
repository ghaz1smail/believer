import 'package:believer/controller/auth_controller.dart';
import 'package:believer/controller/my_app.dart';
import 'package:believer/controller/user_controller.dart';
import 'package:believer/get_initial.dart';
import 'package:believer/models/cart_model.dart';
import 'package:believer/views/screens/product_details.dart';
import 'package:believer/views/widgets/app_bar.dart';
import 'package:believer/views/widgets/counter.dart';
import 'package:believer/views/widgets/remove_cart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  AuthController auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: UserController(),
      builder: (userCubit) {
        return Scaffold(
            appBar: AppBarCustom(
              action: const {},
              title: 'cart'.tr,
            ),
            bottomNavigationBar: userCubit.cartList.isEmpty
                ? null
                : SafeArea(
                    child: Container(
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: 100,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${'subtotal'.tr} (${userCubit.totalCartCount()} ${'items'.tr})',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${'AED'.tr} ${userCubit.totalCartPrice().toStringAsFixed(2)}',
                                )
                              ],
                            ),
                            if (auth.appData!.orders)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: MaterialButton(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  onPressed: () {
                                    if (auth.userData.uid.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: 'pleaseFirst'.tr);
                                      auth.logOut();
                                    } else {
                                      Get.toNamed('checkout');
                                    }
                                  },
                                  height: 45,
                                  minWidth: Get.width,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                  color: appConstant.primaryColor,
                                  child: Text(
                                    'CHECKOUT'.tr,
                                    style: const TextStyle(
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
                width: Get.width,
                height: Get.height,
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
                            Text(
                              'emptyCart'.tr,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
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
                                onTap: () {
                                  Get.to(() => ProductDetails(
                                      product: cart.productData!));
                                },
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
                                    Expanded(
                                      child: Text(
                                        Get.locale!.languageCode == 'ar'
                                            ? cart.productData!.titleAr
                                            : cart.productData!.titleEn,
                                        overflow: TextOverflow.ellipsis,
                                      ),
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
                                      '${'AED'.tr} ${cart.productData!.price}',
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
