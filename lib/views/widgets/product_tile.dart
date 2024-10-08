import 'package:believer/controller/auth_controller.dart';
import 'package:believer/controller/user_controller.dart';
import 'package:believer/get_initial.dart';
import 'package:believer/models/product_model.dart';
import 'package:believer/views/screens/product_details.dart';
import 'package:believer/views/widgets/icon_badge.dart';
import 'package:believer/views/widgets/network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class ProductTile extends StatefulWidget {
  const ProductTile({super.key, required this.product});
  final ProductModel product;

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: UserController(),
      builder: (userCubit) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetails(product: widget.product),
                ));
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(width: 0.4, color: Colors.black26),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Column(
              children: [
                SizedBox(
                  height: 175,
                  child: GridTile(
                      footer: widget.product.stock == 0
                          ? Container()
                          : InkWell(
                              onTap: () {
                                if (userCubit.cartList
                                    .containsKey(widget.product.id)) {
                                  if (userCubit
                                          .cartList[widget.product.id]!.count <
                                      widget.product.stock) {
                                    userCubit.addToCart(widget.product, 1);
                                  }
                                } else {
                                  userCubit.addToCart(widget.product, 1);
                                }
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: AnimatedContainer(
                                  margin: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                  duration: const Duration(milliseconds: 250),
                                  width: userCubit.cartList
                                          .containsKey(widget.product.id)
                                      ? 60
                                      : 30,
                                  height: 30,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Row(
                                      children: [
                                        Icon(
                                          LineAwesome.cart_arrow_down_solid,
                                          color: appConstant.primaryColor,
                                          size: 20,
                                        ),
                                        if (userCubit.cartList
                                            .containsKey(widget.product.id))
                                          const SizedBox(
                                            width: 2.5,
                                          ),
                                        if (userCubit.cartList
                                            .containsKey(widget.product.id))
                                          SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: BadgeIcon(
                                                  badgeText: userCubit
                                                      .cartList[
                                                          widget.product.id]!
                                                      .count
                                                      .toString()))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      child: widget.product.media!.isNotEmpty
                          ? ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              child: NImage(
                                url: widget.product.media![0],
                                h: 100,
                                w: Get.width,
                              ))
                          : const SizedBox()),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          Get.locale!.languageCode == 'ar'
                              ? widget.product.titleAr
                              : widget.product.titleEn,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Get.find<AuthController>().userData.uid.isEmpty
                          ? InkWell(
                              onTap: () async {
                                await userCubit.favoriteStatus(widget.product);
                              },
                              child: const Icon(
                                Icons.favorite_border,
                                color: Colors.red,
                                size: 18,
                              ),
                            )
                          : widget.product.id.isNotEmpty
                              ? StreamBuilder(
                                  stream: firestore
                                      .collection('products')
                                      .doc(widget.product.id)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      ProductModel product =
                                          ProductModel.fromJson(
                                              snapshot.data!.data() as Map);
                                      return InkWell(
                                        onTap: () async {
                                          await userCubit
                                              .favoriteStatus(product);
                                        },
                                        child: Icon(
                                          product.favorites!.contains(
                                                  firebaseAuth.currentUser?.uid)
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.red,
                                          size: 18,
                                        ),
                                      );
                                    }

                                    return InkWell(
                                      onTap: () async {
                                        await userCubit
                                            .favoriteStatus(widget.product);
                                      },
                                      child: Icon(
                                        widget.product.favorites!.contains(
                                                firebaseAuth.currentUser!.uid)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                    );
                                  })
                              : const SizedBox(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Row(
                      children: [
                        Text(
                          '${'AED'.tr} ${widget.product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                              decoration: widget.product.discount == 0
                                  ? null
                                  : TextDecoration.lineThrough),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        if (widget.product.discount != 0)
                          Text(
                            (widget.product.price -
                                    (widget.product.price *
                                        (widget.product.discount / 100)))
                                .toStringAsFixed(2),
                          ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
