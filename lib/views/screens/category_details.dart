// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:believer/controller/my_app.dart';
import 'package:believer/models/category_model.dart';
import 'package:believer/views/screens/admin_categories.dart';
import 'package:believer/views/widgets/app_bar.dart';
import 'package:believer/views/widgets/edit_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hl_image_picker/hl_image_picker.dart';

class CategoryDetails extends StatefulWidget {
  const CategoryDetails({super.key, required this.category, this.catId = ''});
  final CategoryModel category;
  final String catId;

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  GlobalKey<FormState> key = GlobalKey();
  final List<HLPickerItem> imageFile = [];
  bool loading = false;
  TextEditingController ar = TextEditingController(),
      en = TextEditingController();

  updateData() async {
    if (!key.currentState!.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });
    var id = DateTime.now().millisecondsSinceEpoch.toString(), url = '';
    if (imageFile.isNotEmpty) {
      final ref = await firebaseStorage
          .ref(
              'categories/${widget.category.id.isEmpty ? id : widget.category.id}')
          .putFile(File(imageFile.first.path),
              SettableMetadata(contentType: 'image/png'));

      url = await ref.ref.getDownloadURL();
    }
    if (widget.category.id.isEmpty) {
      final link = await staticFunctions.generateLink(id, 'category');
      if (widget.catId.isEmpty) {
        await firestore.collection('categories').doc(id).set({
          'id': id,
          'timestamp': DateTime.now().toIso8601String(),
          'link': link,
          'titleAr': ar.text,
          'titleEn': en.text,
          'url': url.isEmpty ? widget.category.url : url
        });
      } else {
        await firestore
            .collection('categories')
            .doc(widget.catId)
            .collection('categories')
            .doc(id)
            .set({
          'id': id,
          'timestamp': DateTime.now().toIso8601String(),
          'link': link,
          'titleAr': ar.text,
          'titleEn': en.text,
          'url': url.isEmpty ? widget.category.url : url
        });
      }
    } else {
      if (widget.catId.isEmpty) {
        await firestore
            .collection('categories')
            .doc(widget.category.id)
            .update({
          'titleAr': ar.text,
          'titleEn': en.text,
          'url': url.isEmpty ? widget.category.url : url
        });
      } else {
        await firestore
            .collection('categories')
            .doc(widget.catId)
            .collection('categories')
            .doc(widget.category.id)
            .update({
          'titleAr': ar.text,
          'titleEn': en.text,
          'url': url.isEmpty ? widget.category.url : url
        });
      }
    }
    setState(() {
      loading = false;
    });
    Navigator.pop(context);
  }

  _openPicker() async {
    try {
      final images = await HLImagePicker().openPicker(
        selectedIds: imageFile.map((e) => e.id).toList(),
        pickerOptions: const HLPickerOptions(
          mediaType: MediaType.image,
          compressFormat: CompressFormat.png,
          maxSelectedAssets: 1,
        ),
      );

      setState(() {
        imageFile.add(images.first);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    if (widget.category.id.isNotEmpty) {
      ar.text = widget.category.titleAr;
      en.text = widget.category.titleEn;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: widget.category.titleEn,
        action: {
          'function': updateData,
          'icon': widget.category.id.isEmpty ? Icons.add : Icons.edit
        },
        loading: loading,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Form(
            key: key,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _openPicker();
                  },
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100)),
                      child: imageFile.isEmpty
                          ? widget.category.id.isEmpty
                              ? Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(100))),
                                  child: const Icon(
                                    Icons.photo,
                                    size: 50,
                                  ))
                              : CachedNetworkImage(
                                  imageUrl: widget.category.url,
                                  fit: BoxFit.fill,
                                )
                          : Image.file(
                              File(imageFile.first.path),
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                EditText(
                  function: updateData,
                  controller: en,
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return 'Pleaser enter banner title in English';
                    }
                    return null;
                  },
                  hint: 'Offers',
                  title: 'Title in English',
                ),
                const SizedBox(
                  height: 10,
                ),
                EditText(
                  function: updateData,
                  controller: ar,
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return 'Pleaser enter banner title in Arabic';
                    }
                    return null;
                  },
                  hint: 'عروض',
                  title: 'Title in Arabic',
                ),
                const SizedBox(
                  height: 10,
                ),
                if (widget.category.id.isNotEmpty && !loading)
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminCategories(
                                category: widget.category,
                              ),
                            ));
                      },
                      child: const Text(
                        'Sub categories',
                        style: TextStyle(color: Colors.black),
                      )),
                if (widget.category.id.isNotEmpty && !loading)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      child: IconButton(
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            if (widget.catId.isEmpty) {
                              await firestore
                                  .collection('categories')
                                  .doc(widget.category.id)
                                  .delete();
                            } else {
                              await firestore
                                  .collection('categories')
                                  .doc(widget.catId)
                                  .collection('categories')
                                  .doc(widget.category.id)
                                  .delete();
                            }

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
          ),
        ),
      ),
    );
  }
}
