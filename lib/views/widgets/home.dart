import 'package:believer/get_initial.dart';
import 'package:believer/models/banner_model.dart';
import 'package:believer/models/category_model.dart';
import 'package:believer/models/product_model.dart';
import 'package:believer/views/screens/category_screen.dart';
import 'package:believer/views/widgets/network_image.dart';
import 'package:believer/views/widgets/product_tile.dart';
import 'package:believer/views/widgets/shimmer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int current = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          color: appConstant.primaryColor,
          onRefresh: () async {
            setState(() {});
          },
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                margin: const EdgeInsets.only(top: 5),
                height: 95,
                width: Get.width,
                child: FutureBuilder(
                  future: firestore.collection('categories').get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<CategoryModel> data = snapshot.data!.docs
                          .map((doc) => CategoryModel.fromJson(doc.data()))
                          .toList();
                      if (data.isEmpty) {
                        return const SizedBox();
                      }
                      return ListView.builder(
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
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 7.5),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 70,
                                      width: 70,
                                      margin: const EdgeInsets.only(bottom: 5),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: appConstant.primaryColor,
                                            width: 0.1),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(100)),
                                      ),
                                      child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(100)),
                                          child: NImage(
                                            url: category.url,
                                            h: 70,
                                            w: Get.width,
                                          )),
                                    ),
                                    Text(
                                      Get.locale!.languageCode == 'ar'
                                          ? category.titleAr
                                          : category.titleEn,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 11),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                    return ListView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Shimmers(
                          child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 7.5),
                        child: Column(
                          children: [
                            const CircleAvatar(
                              radius: 35,
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                  color: appConstant.primaryColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              height: 5,
                              width: 20,
                            )
                          ],
                        ),
                      )),
                    );
                  },
                ),
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
                          options: CarouselOptions(
                              autoPlay: true,
                              height: 200,
                              viewportFraction: 1,
                              autoPlayInterval: const Duration(seconds: 30)),
                          items: data.map((i) {
                            return Container(
                              width: Get.width,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: NImage(
                                url: i.url,
                                h: 200,
                                w: Get.width,
                                fit: BoxFit.cover,
                              ),
                            );
                          }).toList(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: data.asMap().entries.map((entry) {
                            return Container(
                              width: 8.0,
                              height: 8.0,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (appConstant.primaryColor).withOpacity(
                                      current == entry.key ? 0.9 : 0.4)),
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
                          width: Get.width,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              color: appConstant.primaryColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text(
                  'best'.tr,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: FutureBuilder(
                  future: firestore
                      .collection('products')
                      .orderBy('seller')
                      .limit(50)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<ProductModel> data = snapshot.data!.docs
                          .map((doc) => ProductModel.fromJson(doc.data()))
                          .toList();
                      if (data.isEmpty) {
                        return const SizedBox();
                      }
                      return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                  childAspectRatio: 0.7),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return ProductTile(product: data[index]);
                          });
                    }
                    return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                                childAspectRatio: 0.7),
                        itemCount: 6,
                        itemBuilder: (context, index) => Shimmers(
                            child: ProductTile(
                                product:
                                    ProductModel(favorites: [], media: []))));
                  },
                ),
              )
            ]),
          ),
        ));
  }
}
