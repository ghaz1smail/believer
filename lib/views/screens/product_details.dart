import 'package:believer/controller/my_app.dart';
import 'package:believer/cubit/user_cubit.dart';
import 'package:believer/models/product_model.dart';
import 'package:believer/views/screens/user_screen.dart';
import 'package:believer/views/widgets/app_bar.dart';
import 'package:believer/views/widgets/counter.dart';
import 'package:believer/views/widgets/rating_stars.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key, required this.product});
  final ProductModel product;
  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool favorite = false;
  final PageController _pageController = PageController();
  int _activePage = 0, count = 1;

  @override
  void initState() {
    favorite =
        widget.product.favorites!.contains(firebaseAuth.currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Scaffold(
            appBar: const AppBarCustom(action: {}),
            backgroundColor: Colors.white,
            bottomNavigationBar: SafeArea(
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.1,
                      blurRadius: 0.1,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: widget.product.stock == 0
                    ? Align(
                        child: Text(
                          'Out of stock',
                          style: TextStyle(
                              fontSize: 20,
                              color: primaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Counter(
                            remove: () {
                              setState(() {
                                count--;
                              });
                            },
                            other: () {},
                            add: () {
                              if (count < widget.product.stock) {
                                setState(() {
                                  count++;
                                });
                              }
                            },
                            count: count,
                          ),
                          MaterialButton(
                            onPressed: () {
                              userCubit.addToCart(widget.product, count);
                              Navigator.pop(context);
                            },
                            color: primaryColor,
                            minWidth: dWidth / 2,
                            textColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100))),
                            child: const Text('Add to cart'),
                          )
                        ],
                      ),
              ),
            ),
            body: ListView(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 250,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _activePage = page;
                          });
                        },
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.product.media!.length,
                        itemBuilder: (context, index) => CachedNetworkImage(
                          imageUrl: widget.product.media![index],
                          width: dWidth,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white,
                              child: StreamBuilder(
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
                                          await userCubit
                                              .favoriteStatus(product);
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
                                  }),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white,
                              child: InkWell(
                                onTap: () async {
                                  staticFunctions
                                      .shareData(widget.product.link);
                                },
                                child: Icon(
                                  Icons.reply,
                                  color: primaryColor,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                      widget.product.media!.length,
                      (index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: InkWell(
                              onTap: () {
                                _pageController.animateToPage(index,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn);
                              },
                              child: CircleAvatar(
                                radius: 4,
                                backgroundColor: _activePage == index
                                    ? primaryColor
                                    : Colors.grey,
                              ),
                            ),
                          )),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product.titleEn,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                StarRating(
                                  rate: widget.product.rate ?? [],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'AED ${widget.product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (widget.product.descriptionEn.isNotEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              'Description',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        if (widget.product.descriptionEn.isNotEmpty)
                          Text(
                            widget.product.descriptionEn,
                            style: const TextStyle(fontSize: 16),
                          ),
                      ]),
                )
              ],
            ));
      },
    );
  }
}
