// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:believer/controller/my_app.dart';
import 'package:believer/models/category_model.dart';
import 'package:believer/models/product_model.dart';
import 'package:believer/views/widgets/app_bar.dart';
import 'package:believer/views/widgets/category_picker_bottom_sheet.dart';
import 'package:believer/views/widgets/edit_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hl_image_picker/hl_image_picker.dart';

class AdminProductDetails extends StatefulWidget {
  const AdminProductDetails({super.key, required this.product});
  final ProductModel product;

  @override
  State<AdminProductDetails> createState() => _AdminProductDetailsState();
}

class _AdminProductDetailsState extends State<AdminProductDetails> {
  bool loading = false;
  GlobalKey<FormState> key = GlobalKey();
  final List<HLPickerItem> selectedImages = [];
  String cat = '', mainCat = '';
  TextEditingController tar = TextEditingController(),
      ten = TextEditingController(),
      dar = TextEditingController(),
      den = TextEditingController(),
      stock = TextEditingController(),
      price = TextEditingController();

  Future<List<CategoryModel>> fetchCategories() async {
    List<CategoryModel> results = [];

    QuerySnapshot querySnapshot =
        await firestore.collection('categories').get();

    for (var document in querySnapshot.docs) {
      results
          .add(CategoryModel.fromJson(document.data() as Map<String, dynamic>));
    }

    if (mainCat.isEmpty) {
      if (widget.product.id.isEmpty) {
        mainCat = '${results[0].titleEn}%${results[0].id}';
      } else {
        var c = results
            .where((element) => element.id == widget.product.mainCategory);
        if (c.isEmpty) {
          mainCat = '${results[0].titleEn}%${results[0].id}';
        } else {
          mainCat = '${c.first.titleEn}%${c.first.id}';
        }
      }
      setState(() {});
    }

    return results;
  }

  Future<List<CategoryModel>> fetchSubCategories() async {
    List<CategoryModel> results = [];

    QuerySnapshot querySnapshot = await firestore
        .collection('categories')
        .doc(mainCat.split('%')[1])
        .collection('categories')
        .get();

    for (var document in querySnapshot.docs) {
      results
          .add(CategoryModel.fromJson(document.data() as Map<String, dynamic>));
    }

    if (cat.isEmpty) {
      var c = results.where((element) => element.id == widget.product.category);
      if (c.isNotEmpty) {
        cat = '${c.first.titleEn}%${c.first.id}';
      }
    }

    return results;
  }

  update() async {
    if (!key.currentState!.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });
    var id = DateTime.now().millisecondsSinceEpoch.toString();
    List media = widget.product.media ?? [];

    for (var e in selectedImages) {
      if (!media.contains(e.id)) {
        var id2 = DateTime.now().millisecondsSinceEpoch.toString();
        final ref =
            await firebaseStorage.ref('products/$id2').putFile(File(e.path));

        media.add(await ref.ref.getDownloadURL());
      }
    }

    if (widget.product.id.isEmpty) {
      final link = await staticFunctions.generateLink(id, 'product');
      await firestore.collection('products').doc(id).set({
        'id': id,
        'timestamp': DateTime.now().toIso8601String(),
        'link': link,
        'titleAr': tar.text,
        'titleEn': ten.text,
        'descriptionAr': dar.text,
        'descriptionEn': den.text,
        'favorites': [],
        'category': cat.split('%')[1],
        'mainCategory': mainCat.split('%')[1],
        'dicount': 0,
        'seller': 0,
        'media': media,
        'extra': [],
        'rate': [],
        'price': double.parse(price.text),
        'stock': int.parse(stock.text)
      });
    } else {
      await firestore.collection('products').doc(widget.product.id).update({
        'titleAr': tar.text,
        'titleEn': ten.text,
        'descriptionAr': dar.text,
        'descriptionEn': den.text,
        'media': media,
        'category': cat.split('%')[1],
        'mainCategory': mainCat.split('%')[1],
        'price': double.parse(price.text),
        'stock': int.parse(stock.text)
      });
    }

    Navigator.pop(context);
  }

  _openPicker() async {
    try {
      final images = await HLImagePicker().openPicker(
        selectedIds: selectedImages.map((e) => e.id).toList(),
        pickerOptions: const HLPickerOptions(
          mediaType: MediaType.image,
          compressQuality: 0,
          compressFormat: CompressFormat.png,
          maxSelectedAssets: 5,
        ),
      );
      for (var element in images) {
        setState(() {
          selectedImages.add(element);
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    if (widget.product.id.isNotEmpty) {
      for (var e in widget.product.media!) {
        selectedImages.add(HLPickerItem(
            id: e,
            path: e,
            name: e,
            mimeType: 'image',
            size: 0,
            width: 100,
            height: 100,
            type: 'image'));
      }

      tar.text = widget.product.titleAr;
      ten.text = widget.product.titleEn;
      dar.text = widget.product.descriptionAr;
      den.text = widget.product.descriptionEn;
      price.text = widget.product.price.toStringAsFixed(2);
      stock.text = widget.product.stock.toString();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
          title: widget.product.titleEn,
          loading: loading,
          action: {
            'icon': widget.product.id.isEmpty ? Icons.add : Icons.edit,
            'function': update
          }),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: key,
            child: ListView(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: selectedImages.length == 5
                      ? selectedImages.length
                      : selectedImages.length + 1,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemBuilder: (context, index) {
                    String imageFile = index != selectedImages.length
                        ? selectedImages[index].path
                        : '';

                    return GestureDetector(
                      onTap: () {
                        _openPicker();
                      },
                      child: index == selectedImages.length
                          ? Container(
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: const Icon(Icons.add))
                          : Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  child: imageFile.startsWith(
                                    'https',
                                  )
                                      ? CachedNetworkImage(
                                          imageUrl: imageFile,
                                          height: 125,
                                          width: 125,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          File(imageFile),
                                          height: 125,
                                          width: 125,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedImages.removeAt(index);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                EditText(
                    function: () {},
                    controller: ten,
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return 'Please enter product title in English';
                      }
                      return null;
                    },
                    hint: 'Iphone',
                    title: 'Product title in English'),
                const SizedBox(
                  height: 20,
                ),
                EditText(
                    function: () {},
                    controller: tar,
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return 'Please enter product title in Arabic';
                      }
                      return null;
                    },
                    hint: 'ايفون',
                    title: 'Product title in Arabic'),
                const Padding(
                  padding: EdgeInsets.only(left: 5, top: 20),
                  child: Text('Main category'),
                ),
                FutureBuilder(
                    future: fetchCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<CategoryModel> data = snapshot.data!;

                        return GestureDetector(
                          onTap: () {
                            staticWidgets.showBottom(
                                context,
                                CategoryPickerBottomSheet(
                                    list: data,
                                    function: (c) {
                                      setState(() {
                                        mainCat = c;
                                        cat = '';
                                      });
                                    }),
                                0.5,
                                0.75);
                          },
                          child: Container(
                            width: dWidth,
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Text(mainCat.split('%')[0]),
                          ),
                        );
                      }
                      return const Text('Loading...');
                    }),
                const Padding(
                  padding: EdgeInsets.only(left: 5, top: 10),
                  child: Text('Sub category'),
                ),
                FutureBuilder(
                    future: fetchSubCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<CategoryModel> data = snapshot.data!;

                        return GestureDetector(
                          onTap: () {
                            staticWidgets.showBottom(
                                context,
                                CategoryPickerBottomSheet(
                                    list: data,
                                    function: (c) {
                                      setState(() {
                                        cat = c;
                                      });
                                    }),
                                0.5,
                                0.75);
                          },
                          child: Container(
                            width: dWidth,
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Text(cat.split('%')[0]),
                          ),
                        );
                      }
                      return const Text('Loading...');
                    }),
                const SizedBox(
                  height: 20,
                ),
                EditText(
                    function: () {},
                    controller: den,
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return 'Please enter product descrition in English';
                      }
                      return null;
                    },
                    hint: 'storage 64',
                    title: 'Product descrition in English'),
                const SizedBox(
                  height: 20,
                ),
                EditText(
                    function: () {},
                    controller: dar,
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return 'Please enter product descrition in Arabic';
                      }
                      return null;
                    },
                    hint: 'مساحة ٦٤',
                    title: 'Product descrition in Arabic'),
                const SizedBox(
                  height: 20,
                ),
                EditText(
                    function: () {},
                    controller: price,
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return 'Please enter product price';
                      }
                      return null;
                    },
                    hint: '100',
                    number: true,
                    title: 'Product price'),
                const SizedBox(
                  height: 20,
                ),
                EditText(
                    function: () {},
                    controller: stock,
                    number: true,
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return 'Please enter product stock';
                      }
                      return null;
                    },
                    hint: '5',
                    title: 'Product stock'),
                if (widget.product.id.isNotEmpty && !loading)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      child: IconButton(
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            await firestore
                                .collection('products')
                                .doc(widget.product.id)
                                .delete();
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    ),
                  )
              ],
            ),
          )),
    );
  }
}
