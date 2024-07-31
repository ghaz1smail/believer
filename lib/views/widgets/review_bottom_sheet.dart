import 'package:believer/controller/auth_controller.dart';
import 'package:believer/controller/my_app.dart';
import 'package:believer/get_initial.dart';
import 'package:believer/views/widgets/edit_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class BottomSheetReview extends StatefulWidget {
  const BottomSheetReview({super.key, this.id = ''});
  final String id;

  @override
  State<BottomSheetReview> createState() => _BottomSheetReviewState();
}

class _BottomSheetReviewState extends State<BottomSheetReview> {
  bool loading = false;
  double _rating = 0;
  TextEditingController message = TextEditingController();

  submit() async {
    FocusScope.of(context).unfocus();

    setState(() {
      loading = true;
    });
    var id = DateTime.now();
    await firestore
        .collection('reviews')
        .doc(id.millisecondsSinceEpoch.toString())
        .set({
      'id': id.millisecondsSinceEpoch.toString(),
      'timestamp': id.toIso8601String(),
      'name': Get.find<AuthController>().userData.name,
      'orderId': widget.id,
      'rate': _rating,
      'message': message.text,
      'uid': firebaseAuth.currentUser!.uid
    });
    await firestore.collection('orders').doc(widget.id).update({
      'rated': true,
    });
    Get.back();
    Fluttertoast.showToast(msg: 'reviewSent'.tr);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: staticWidgets.scrollController,
      children: [
        const SizedBox(
          height: 20,
        ),
        Center(
          child: Text(
            'reviewOrder'.tr,
            style: const TextStyle(fontSize: 25),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 20),
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              double sensitivity = 8.0;
              if (details.primaryDelta! > sensitivity) {
                setState(() {
                  _rating += 0.5;
                  if (_rating > 5.0) _rating = 5.0;
                });
              } else if (details.primaryDelta! < -sensitivity) {
                setState(() {
                  _rating -= 0.5;
                  if (_rating < 0.0) _rating = 0.0;
                });
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (index + 1 == _rating) {
                        _rating = index + 0.5;
                      } else {
                        _rating = index + 1.0;
                      }
                    });
                  },
                  child: Icon(
                    index + 1 <= _rating
                        ? Icons.star
                        : (index + 0.5 <= _rating
                            ? Icons.star_half
                            : Icons.star_border),
                    size: 40,
                    color: Colors.red,
                  ),
                );
              }),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
          child: EditText(
              hint: 'veryGood'.tr,
              function: submit,
              controller: message,
              validator: (value) => '',
              title: 'message'),
        ),
        Center(
          child: loading
              ? const CircularProgressIndicator()
              : MaterialButton(
                  minWidth: 100,
                  height: 40,
                  onPressed: () async {
                    submit();
                  },
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  color: appConstant.primaryColor,
                  child: Text(
                    'submit'.tr,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
        )
      ],
    );
  }
}
