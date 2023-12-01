import 'package:believer/controller/my_app.dart';
import 'package:believer/models/product_model.dart';
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
                  Iterable result = data.where(
                      (element) => element.titleEn.contains(controller.text));
                  return result.isEmpty
                      ? Image.asset('assets/images/no_result.png')
                      : ListView.builder(
                          itemCount: result.length,
                          itemBuilder: (context, index) {
                            return Container();
                          },
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
