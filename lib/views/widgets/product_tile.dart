import 'package:believer/controller/my_app.dart';
import 'package:believer/cubit/user_cubit.dart';
import 'package:believer/models/product_model.dart';
import 'package:believer/views/screens/product_details.dart';
import 'package:believer/views/screens/user_screen.dart';
import 'package:believer/views/widgets/icon_badge.dart';
import 'package:believer/views/widgets/network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
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
                Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.4, color: Colors.black26),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  margin: const EdgeInsets.only(bottom: 5),
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
                                          color: primaryColor,
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
                      child: Container(
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        height: 100,
                        width: 100,
                        child: widget.product.media!.isNotEmpty
                            ? ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                child: NImage(
                                    url: widget.product.media![0], h: 100))
                            : const SizedBox(),
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.product.titleEn,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      widget.product.id.isNotEmpty
                          ? StreamBuilder(
                              stream: firestore
                                  .collection('products')
                                  .doc(widget.product.id)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  ProductModel product = ProductModel.fromJson(
                                      snapshot.data!.data() as Map);
                                  return InkWell(
                                    onTap: () async {
                                      await userCubit.favoriteStatus(product);
                                    },
                                    child: Icon(
                                      product.favorites!.contains(
                                              firebaseAuth.currentUser!.uid)
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
                  child: Row(
                    children: [
                      Text(
                        'AED ${widget.product.price.toStringAsFixed(2)}',
                      ),
                    ],
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
