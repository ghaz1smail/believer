import 'package:believer/controller/my_app.dart';
import 'package:believer/models/product_model.dart';
import 'package:believer/views/screens/admin_product_details.dart';
import 'package:believer/views/widgets/app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminProducts extends StatefulWidget {
  const AdminProducts({super.key});

  @override
  State<AdminProducts> createState() => _AdminProductsState();
}

class _AdminProductsState extends State<AdminProducts> {
  TextEditingController search = TextEditingController();
  Iterable<ProductModel> result = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: 'Products', action: {
        'icon': Icons.add,
        'function': () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminProductDetails(
                  product: ProductModel(titleEn: 'New product'),
                ),
              ));
          setState(() {});
        }
      }),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: firestore.collection('products').get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ProductModel> data = snapshot.data!.docs
                  .map((e) => ProductModel.fromJson(e.data()))
                  .toList();
              result = data.where((a) =>
                  a.titleEn.toLowerCase().contains(search.text.toLowerCase()) ||
                  a.titleAr.toLowerCase().contains(search.text.toLowerCase()));

              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    CupertinoSearchTextField(
                      controller: search,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    result.isEmpty
                        ? Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/no_result.png'),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text('No data found')
                              ],
                            ),
                          )
                        : Expanded(
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                color: Colors.grey,
                              ),
                              itemCount: result.length,
                              itemBuilder: (context, index) {
                                ProductModel product = result.toList()[index];
                                return ListTile(
                                  leading: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    child: CachedNetworkImage(
                                      imageUrl: product.media![0],
                                      width: 75,
                                      height: 75,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  onTap: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AdminProductDetails(
                                            product: product,
                                          ),
                                        ));
                                    setState(() {});
                                  },
                                  title: Text(
                                    product.titleEn,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    'AED ${product.price}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
