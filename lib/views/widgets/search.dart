import 'package:believer/controller/my_app.dart';
import 'package:believer/models/product_model.dart';
import 'package:believer/views/screens/product_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          CupertinoSearchTextField(
            controller: controller,
            onChanged: (value) {
              setState(() {});
            },
          ),
          Expanded(
            child: FutureBuilder(
              future: firestore.collection('products').get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ProductModel> data = snapshot.data!.docs
                      .map((e) => ProductModel.fromJson(e.data()))
                      .toList();
                  Iterable result = data.where((element) =>
                      element.titleEn
                          .toLowerCase()
                          .contains(controller.text.toLowerCase()) ||
                      element.titleAr
                          .toLowerCase()
                          .contains(controller.text.toLowerCase()));
                  return result.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/empty_data.png',
                              height: 150,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text('No products found')
                          ],
                        )
                      : RefreshIndicator(
                          color: primaryColor,
                          onRefresh: () async {
                            setState(() {});
                          },
                          child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: result.length,
                            itemBuilder: (context, index) {
                              ProductModel product = result.toList()[index];
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetails(product: product),
                                        ));
                                  },
                                  leading: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    child: CachedNetworkImage(
                                      imageUrl: product.media![0],
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    product.titleEn,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  visualDensity:
                                      const VisualDensity(vertical: 4),
                                  subtitle: Text(
                                    'AED ${product.price}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          )
        ],
      ),
    );
  }
}
