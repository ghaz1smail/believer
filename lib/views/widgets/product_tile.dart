import 'package:believer/controller/my_app.dart';
import 'package:believer/cubit/user_cubit.dart';
import 'package:believer/models/product_model.dart';
import 'package:believer/views/screens/product_details.dart';
import 'package:believer/views/screens/user_screen.dart';
import 'package:believer/views/widgets/counter.dart';
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
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                margin: const EdgeInsets.only(bottom: 5),
                height: 200,
                child: GridTile(
                    header: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        margin: const EdgeInsets.all(5),
                        child: widget.product.id.isNotEmpty
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
                                    return IconButton(
                                      icon: Icon(
                                        product.favorites!.contains(
                                                firebaseAuth.currentUser!.uid)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                      onPressed: () async {
                                        await userCubit.favoriteStatus(product);
                                      },
                                    );
                                  }

                                  return IconButton(
                                    icon: Icon(
                                      widget.product.favorites!.contains(
                                              firebaseAuth.currentUser!.uid)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                    onPressed: () async {
                                      await userCubit
                                          .favoriteStatus(widget.product);
                                    },
                                  );
                                })
                            : const SizedBox(),
                      ),
                    ),
                    footer: Align(
                      alignment: Alignment.centerRight,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: userCubit.cartList.containsKey(widget.product.id)
                            ? 100
                            : 35,
                        height: 35,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        margin: const EdgeInsets.all(5),
                        child: userCubit.cartList.containsKey(widget.product.id)
                            ? FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Counter(
                                  remove: () {
                                    userCubit.addToCart(widget.product, -1);
                                  },
                                  add: () {
                                    userCubit.addToCart(widget.product, 1);
                                  },
                                  other: () {
                                    userCubit.removeFromCart(widget.product.id);
                                  },
                                  count: userCubit
                                      .cartList[widget.product.id]!.count,
                                ),
                              )
                            : IconButton(
                                icon: const Icon(
                                  BoxIcons.bx_cart_add,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                                onPressed: () {
                                  userCubit.addToCart(widget.product, 1);
                                },
                              ),
                      ),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      height: 100,
                      width: 100,
                      child: widget.product.media!.isNotEmpty
                          ? ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              child:
                                  NImage(url: widget.product.media![0], h: 100))
                          : const SizedBox(),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                child: Text(
                  widget.product.titleEn,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Row(
                  children: [
                    Text('AED ${widget.product.price.toStringAsFixed(2)}'),
                    const Spacer(),
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: Colors.amber,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text('5.0'),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
