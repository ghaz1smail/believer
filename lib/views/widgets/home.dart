import 'package:believer/controller/my_app.dart';
import 'package:believer/cubit/user_cubit.dart';
import 'package:believer/models/banner_model.dart';
import 'package:believer/models/category_model.dart';
import 'package:believer/models/product_model.dart';
import 'package:believer/views/screens/category_screen.dart';
import 'package:believer/views/screens/splash_screen.dart';
import 'package:believer/views/widgets/network_image.dart';
import 'package:believer/views/widgets/product_tile.dart';
import 'package:believer/views/widgets/shimmer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CarouselController controller = CarouselController();
  int current = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: false,
          title: Text(
            'Hi ${auth.userData.name}',
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.apps,
                    color: Colors.black,
                  )),
            ),
            const SizedBox(
              width: 5,
            ),
            CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.black,
                  )),
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
        body: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            return RefreshIndicator(
              color: primaryColor,
              onRefresh: () async {
                setState(() {});
              },
              child: ListView(children: [
                FutureBuilder(
                  future: firestore.collection('categories').get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<CategoryModel> data = snapshot.data!.docs
                          .map((doc) => CategoryModel.fromJson(doc.data()))
                          .toList();
                      if (data.isEmpty) {
                        return const SizedBox();
                      }
                      return SizedBox(
                        height: 100,
                        width: dWidth,
                        child: ListView.builder(
                            itemCount: data.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              CategoryModel category = data[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CategoryScreen(
                                          category: category,
                                        ),
                                      ));
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: SizedBox(
                                    width: 70,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: primaryColor),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(100)),
                                          ),
                                          child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(100)),
                                              child: NImage(
                                                url: category.url,
                                                h: 70,
                                              )),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 5),
                                          height: 20,
                                          child: Text(
                                            category.titleEn,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                    return SizedBox(
                      height: 100,
                      width: dWidth,
                      child: ListView.builder(
                        itemCount: 5,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => Shimmers(
                            child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              const CircleAvatar(
                                radius: 35,
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                decoration: const BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                height: 20,
                                width: 20,
                              )
                            ],
                          ),
                        )),
                      ),
                    );
                  },
                ),
                FutureBuilder(
                  future: firestore.collection('banners').get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<BannerModel> data = snapshot.data!.docs
                          .map((doc) => BannerModel.fromJson(doc.data()))
                          .toList();
                      if (data.isEmpty) {
                        return const SizedBox();
                      }
                      return Column(
                        children: [
                          CarouselSlider(
                            carouselController: controller,
                            options: CarouselOptions(
                                autoPlay: true,
                                height: 200,
                                viewportFraction: 1,
                                autoPlayInterval: const Duration(seconds: 30)),
                            items: data.map((i) {
                              return Container(
                                width: dWidth,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: NImage(
                                  url: i.url,
                                  h: 200,
                                  fit: BoxFit.fitWidth,
                                ),
                              );
                            }).toList(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: data.asMap().entries.map((entry) {
                              return GestureDetector(
                                onTap: () =>
                                    controller.animateToPage(entry.key),
                                child: Container(
                                  width: 8.0,
                                  height: 8.0,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: (primaryColor).withOpacity(
                                          current == entry.key ? 0.9 : 0.4)),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }
                    return CarouselSlider(
                      options: CarouselOptions(
                        height: 200,
                        enlargeCenterPage: true,
                      ),
                      items: [1, 2].map((i) {
                        return Shimmers(
                          child: Container(
                            width: dWidth,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: FutureBuilder(
                    future: firestore.collection('products').get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<ProductModel> data = snapshot.data!.docs
                            .map((doc) => ProductModel.fromJson(doc.data()))
                            .toList();
                        if (data.isEmpty) {
                          return const SizedBox();
                        }
                        return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15,
                                    childAspectRatio: 0.65),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              ProductModel product = data[index];
                              return ProductTile(product: product);
                            });
                      }
                      return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                  childAspectRatio: 0.65),
                          itemCount: 6,
                          itemBuilder: (context, index) => Shimmers(
                              child: ProductTile(
                                  product:
                                      ProductModel(favorites: [], media: []))));
                    },
                  ),
                )
              ]),
            );
          },
        ));
  }
}
