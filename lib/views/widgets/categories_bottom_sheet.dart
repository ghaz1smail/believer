import 'package:believer/controller/my_app.dart';
import 'package:believer/models/category_model.dart';
import 'package:believer/views/screens/category_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BottomSheetCategories extends StatefulWidget {
  const BottomSheetCategories({super.key});

  @override
  State<BottomSheetCategories> createState() => _BottomSheetCategoriesState();
}

class _BottomSheetCategoriesState extends State<BottomSheetCategories> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        const Center(
          child: Text(
            'Categories',
            style: TextStyle(fontSize: 25),
          ),
        ),
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
              return Flexible(
                  child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GridView.builder(
                  itemCount: data.length,
                  controller: staticWidgets.scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, childAspectRatio: 1.1),
                  itemBuilder: (context, index) {
                    CategoryModel category = data[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryScreen(
                                category: category,
                              ),
                            ));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                          width: 75,
                          child: Column(
                            children: [
                              Container(
                                height: 75,
                                width: 75,
                                decoration: BoxDecoration(
                                  border: Border.all(color: primaryColor),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100)),
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100)),
                                  child: CachedNetworkImage(
                                    imageUrl: category.url,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                height: 20,
                                child: Text(
                                  category.titleEn,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ));
            }
            return const Expanded(
                child: Center(child: CircularProgressIndicator()));
          },
        ),
      ],
    );
  }
}
