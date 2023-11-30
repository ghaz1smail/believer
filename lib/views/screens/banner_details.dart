// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:believer/controller/my_app.dart';
import 'package:believer/models/banner_model.dart';
import 'package:believer/views/widgets/app_bar.dart';
import 'package:believer/views/widgets/edit_text.dart';
import 'package:believer/views/widgets/shimmer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hl_image_picker/hl_image_picker.dart';

class BannnerDetails extends StatefulWidget {
  const BannnerDetails({super.key, required this.banner});
  final BannerModel banner;

  @override
  State<BannnerDetails> createState() => _BannnerDetailsState();
}

class _BannnerDetailsState extends State<BannnerDetails> {
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
          .ref('banners/${widget.banner.id.isEmpty ? id : widget.banner.id}')
          .putFile(File(imageFile.first.path),
              SettableMetadata(contentType: 'image/png'));

      url = await ref.ref.getDownloadURL();
    }
    if (widget.banner.id.isEmpty) {
      final link = await staticFunctions.generateLink(id, 'banner');
      await firestore.collection('banners').doc(id).set({
        'id': id,
        'timestamp': DateTime.now().toIso8601String(),
        'link': link,
        'titleAr': ar.text,
        'titleEn': en.text,
        'url': url.isEmpty ? widget.banner.url : url
      });
    } else {
      await firestore.collection('banners').doc(widget.banner.id).update({
        'titleAr': ar.text,
        'titleEn': en.text,
        'url': url.isEmpty ? widget.banner.url : url
      });
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
    if (widget.banner.id.isNotEmpty) {
      ar.text = widget.banner.titleAr;
      en.text = widget.banner.titleEn;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: widget.banner.titleEn,
        action: {
          'function': updateData,
          'icon': widget.banner.id.isEmpty ? Icons.edit : Icons.add
        },
        loading: loading,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: key,
          child: ListView(children: [
            GestureDetector(
              onTap: () {
                _openPicker();
              },
              child: SizedBox(
                height: 175,
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: imageFile.isEmpty
                        ? widget.banner.id.isEmpty
                            ? Container(
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                child: const Icon(
                                  Icons.photo,
                                  size: 50,
                                ))
                            : CachedNetworkImage(
                                imageUrl: widget.banner.url,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Shimmers(
                                    child: Container(
                                  height: 175,
                                  width: dWidth,
                                  color: Colors.orangeAccent,
                                )),
                              )
                        : Image.file(
                            File(imageFile.first.path),
                            fit: BoxFit.fitWidth,
                          )),
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
            if (widget.banner.id.isNotEmpty && !loading)
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
                            .collection('banners')
                            .doc(widget.banner.id)
                            .delete();
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      )),
                ),
              )
          ]),
        ),
      ),
    );
  }
}
