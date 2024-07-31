import 'package:believer/controller/auth_controller.dart';
import 'package:believer/controller/user_controller.dart';
import 'package:believer/get_initial.dart';
import 'package:believer/models/cart_model.dart';
import 'package:believer/models/coupon_model.dart';
import 'package:believer/models/order_model.dart';
import 'package:believer/views/screens/order_details.dart';
import 'package:believer/views/screens/product_details.dart';
import 'package:believer/views/widgets/app_bar.dart';
import 'package:believer/views/widgets/edit_text.dart';
import 'package:believer/views/widgets/web_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool makeOrder = false, loading = false;
  CouponModel couponData = CouponModel();
  String url = '';
  TextEditingController code = TextEditingController();
  String invoiceID = '';
  UserController userCubit = Get.find<UserController>();

  AuthController auth = Get.find<AuthController>();

  Future<bool> makePayment(number) async {
    if (url.isNotEmpty) {
      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewer(
              url: url,
            ),
          ));
      return userCubit.done;
    } else {
      return false;
    }
  }

  ordering() async {
    var id = DateTime.now(), numbers = 0, done = false;

    await firestore.collection('orders').get().then((value) {
      numbers = value.size;
    });

    done = await makePayment(numbers);

    if (done) {
      userCubit.changeDone(false);
      Fluttertoast.showToast(msg: 'orderPlaced'.tr);

      for (int i = 0; i < userCubit.cartList.entries.length; i++) {
        await firestore
            .collection('products')
            .doc(userCubit.cartList.entries.toList()[i].key)
            .update({
          'stock': FieldValue.increment(
              -userCubit.cartList.entries.toList()[i].value.count),
          'seller': FieldValue.increment(1)
        });
      }

      var data = {
        'number': numbers + 1,
        'uid': firebaseAuth.currentUser!.uid,
        'total': userCubit.totalCartPrice(),
        'discount': couponData.discount,
        'delivery': 25,
        'rated': false,
        'status': 'inProgress',
        'name': auth.userData.name,
        'timestamp': id.toIso8601String(),
        'addressData': {
          'address': auth.userData.address!.first.address,
          'phone': auth.userData.address!.first.phone,
          'label': auth.userData.address!.first.label,
          'name': auth.userData.address!.first.name,
        },
        // 'walletData': {
        //   'number': CryptLib.instance.encryptPlainTextWithRandomIV(
        //       auth.userData.wallet!.first.number, "number"),
        // },
        'orderList': userCubit.cartList.entries
            .map((e) => {
                  'id': e.key,
                  'titleEn': e.value.productData!.titleEn,
                  'titleAr': e.value.productData!.titleAr,
                  'price': e.value.productData!.price,
                  'discount': e.value.productData!.discount,
                  'media': [e.value.productData!.media!.first],
                  'count': e.value.count,
                })
            .toList()
      };
      firestore
          .collection('orders')
          .doc(id.millisecondsSinceEpoch.toString())
          .set(data);
      Get.off(() => OrderDetails(order: OrderModel.fromJson(data)));

      userCubit.clearCart();
    } else {
      Fluttertoast.showToast(msg: 'Payment failed');
      setState(() {
        makeOrder = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Container(
            height: 175,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey))),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${'subtotal'.tr}:',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                            '${'AED'.tr} ${userCubit.totalCartPrice().toStringAsFixed(2)}',
                            style: const TextStyle()),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${'discount'.tr}:',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                            '-${'AED'.tr} ${(((userCubit.totalCartPrice() * (couponData.discount / 100)) > couponData.max ? couponData.max : (userCubit.totalCartPrice() * (couponData.discount / 100)))).toStringAsFixed(2)}',
                            style: const TextStyle()),
                      ]),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${'total'.tr}:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: couponData.id.isNotEmpty
                                ? TextDecoration.lineThrough
                                : null),
                      ),
                      Text(
                          '${'AED'.tr} ${(userCubit.totalCartPrice() - ((userCubit.totalCartPrice() * (couponData.discount / 100)) > couponData.max ? couponData.max : (userCubit.totalCartPrice() * (couponData.discount / 100)))).toStringAsFixed(2)}'),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  makeOrder
                      ? const CircularProgressIndicator()
                      : MaterialButton(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          onPressed: () async {
                            if (auth.userData.address!.isNotEmpty) {
                              // if (auth.userData.wallet!.isNotEmpty) {
                              setState(() {
                                makeOrder = true;
                              });

                              await ordering();
                              // } else {
                              //   staticWidgets.showBottom(context,
                              //       const BottomSheetPayment(), 0.85, 0.9);
                              // }
                            } else {
                              Fluttertoast.showToast(msg: 'pleaseAddress'.tr);
                            }
                          },
                          height: 45,
                          minWidth: Get.width,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          color: appConstant.primaryColor,
                          textColor: Colors.white,
                          child: Text('placeOrder'.tr),
                        ),
                ])),
      ),
      appBar: AppBarCustom(
        title: 'CHECKOUT'.tr,
        action: const {},
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
              width: Get.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: userCubit.cartList.length,
                itemBuilder: (context, index) {
                  CartModel cart = userCubit.cartList.values.toList()[index];
                  return SizedBox(
                    width: 275,
                    child: ListTile(
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetails(product: cart.productData!),
                            ));
                      },
                      leading: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: CachedNetworkImage(
                          imageUrl: cart.productData!.media![0],
                          width: 75,
                          height: 75,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        cart.productData!.titleEn,
                        overflow: TextOverflow.ellipsis,
                      ),
                      visualDensity: const VisualDensity(vertical: 4),
                      subtitle: Text(
                        '${'AED'.tr} ${cart.productData!.price}  x${cart.count}',
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),
            auth.userData.address!.isEmpty
                ? Align(
                    child: MaterialButton(
                      minWidth: 0,
                      height: 25,
                      color: appConstant.primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      onPressed: () async {
                        await Navigator.pushNamed(context, 'address');
                        setState(() {});
                      },
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      child: Text(
                        'addNew'.tr,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  )
                : ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.location_on,
                      color: appConstant.primaryColor,
                    ),
                    title: Text(auth.userData.address!.first.name),
                    subtitle: Text(auth.userData.address!.first.address),
                    trailing: MaterialButton(
                      minWidth: 0,
                      height: 25,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      onPressed: () async {
                        await Navigator.pushNamed(context, 'address');
                        setState(() {});
                      },
                      color: appConstant.primaryColor,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      child: Text(
                        'change'.tr,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
            const Divider(
              color: Colors.grey,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Flexible(
                    child: EditText(
                        function: () {},
                        controller: code,
                        validator: (v) => '',
                        hint: '',
                        title: 'promo'),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: loading
                          ? const CircularProgressIndicator()
                          : FloatingActionButton(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100))),
                              backgroundColor: appConstant.primaryColor,
                              mini: true,
                              onPressed: () async {
                                setState(() {
                                  loading = true;
                                });

                                await firestore
                                    .collection('coupons')
                                    .where('code', whereIn: [
                                      code.text.toLowerCase(),
                                      code.text.toUpperCase()
                                    ])
                                    .get()
                                    .then((value) {
                                      if (value.size > 0) {
                                        couponData = CouponModel.fromJson(
                                            value.docs.first.data());

                                        if (couponData.endTime!
                                            .isBefore(DateTime.now())) {
                                          Fluttertoast.showToast(
                                              msg: 'expired'.tr);
                                          couponData = CouponModel();
                                        }
                                      } else {
                                        couponData = CouponModel();
                                        Fluttertoast.showToast(
                                            msg: 'noCode'.tr);
                                      }
                                    });
                                setState(() {
                                  loading = false;
                                });
                              },
                              child: const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 20,
                              )))
                ],
              ),
            ),
            if (couponData.id.isNotEmpty)
              ListTile(
                title: Text(couponData.titleEn),
                trailing: Text('${couponData.discount}%'),
                subtitle: Text(
                    '${'upTo'.tr} ${couponData.max.toStringAsFixed(2)} ${'AED'.tr}'),
              ),
          ],
        ),
      ),
    );
  }
}
