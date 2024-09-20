import 'dart:convert';
import 'package:believer/controller/auth_controller.dart';
import 'package:believer/controller/user_controller.dart';
import 'package:believer/get_initial.dart';
import 'package:believer/models/app_data_model.dart';
import 'package:believer/models/cart_model.dart';
import 'package:believer/models/coupon_model.dart';
import 'package:believer/models/order_model.dart';
import 'package:believer/models/payment_model.dart';
import 'package:believer/views/screens/order_details.dart';
import 'package:believer/views/screens/product_details.dart';
import 'package:believer/views/screens/web_viewer.dart';
import 'package:believer/views/widgets/app_bar.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Paymob? paymob;
  bool makeOrder = false, loading = false;
  CouponModel couponData = CouponModel();
  TextEditingController code = TextEditingController();
  String invoiceID = '';
  var auth = Get.find<AuthController>(),
      userController = Get.find<UserController>();

  makePayment() async {
    try {
      var response = await http.post(
          Uri.parse('https://uae.paymob.com/api/auth/tokens'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(
              {"username": paymob?.username, "password": paymob?.password}));

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = PaymentModel.fromMap(jsonDecode(response.body));
        try {
          var request = await http.post(
              Uri.parse('https://uae.paymob.com/api/ecommerce/payment-links'),
              headers: {
                'Accept': 'application/json',
                'Authorization': 'Bearer ${data.token}',
              },
              body: {
                'amount_cents':
                    (Get.find<UserController>().totalCartPrice() * 100)
                        .toStringAsFixed(2),
                'full_name': auth.userData.name,
                'email': auth.userData.email,
                'phone_number': auth.userData.address!.first.phone,
                'payment_methods': paymob!.id,
                'payment_link_image': '',
                'save_selection': 'false',
                'is_live': 'true'
              });

          if (request.statusCode == 200 || request.statusCode == 201) {
            var data2 = PaymentLink.fromJson(jsonDecode(request.body));
            await Get.to(
              () => WebViewer(
                url: data2.clientUrl,
              ),
            );
          } else {
            Get.log(request.body);
          }
        } catch (e) {
          Get.log(e.toString());
        }
      } else {
        Get.log(response.body);
      }
    } catch (e) {
      Get.log(e.toString());
    }
  }

  ordering() async {
    var id = DateTime.now(), numbers = 0, done = false;

    QuerySnapshot querySnapshot = await firestore
        .collection('orders')
        .orderBy('number', descending: true)
        .limit(1)
        .get();

    numbers = querySnapshot.docs.first.get('number') + 1;

    await makePayment();

    done = userController.done;

    if (done) {
      userController.changeDone(false);
      Fluttertoast.showToast(msg: 'orderPlaced'.tr);

      for (int i = 0; i < userController.cartList.entries.length; i++) {
        await firestore
            .collection('products')
            .doc(userController.cartList.entries.toList()[i].key)
            .update({
          'stock': FieldValue.increment(
              -userController.cartList.entries.toList()[i].value.count),
          'seller': FieldValue.increment(1)
        });
      }

      var data = {
        'number': numbers + 1,
        'uid': firebaseAuth.currentUser!.uid,
        'total': userController.totalCartPrice(),
        'discount': couponData.discount,
        'delivery': 25,
        'rated': false,
        'status': 'inProgress',
        'name': auth.userData.name,
        'invoice': invoiceID,
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
        'orderList': userController.cartList.entries
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
      Get.off(
        () => OrderDetails(order: OrderModel.fromJson(data)),
      );

      userController.clearCart();
    } else {
      Fluttertoast.showToast(msg: 'Payment failed');
      setState(() {
        makeOrder = false;
      });
    }
  }

  @override
  void initState() {
    paymob = auth.appData!.paymobs!
        .firstWhere((w) => w.status, orElse: () => Paymob());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0.5,
                    blurRadius: 0.5,
                    offset: const Offset(0, -2),
                  ),
                ],
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20))),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${'total'.tr}: ${'AED'.tr} ${(userController.totalCartPrice()).toStringAsFixed(2)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: couponData.id.isNotEmpty
                                ? TextDecoration.lineThrough
                                : null),
                      ),
                      if (couponData.id.isNotEmpty)
                        Text(
                          '${'AED'.tr} ${(userController.totalCartPrice() - ((userController.totalCartPrice() * (couponData.discount / 100)) > couponData.max ? couponData.max : (userController.totalCartPrice() * (couponData.discount / 100)))).toStringAsFixed(2)} ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  makeOrder
                      ? const CircularProgressIndicator()
                      : MaterialButton(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          onPressed: () async {
                            if (paymob!.id.isNotEmpty) {
                              if (auth.userData.address!.isNotEmpty) {
                                setState(() {
                                  makeOrder = true;
                                });

                                await ordering();

                                setState(() {
                                  makeOrder = false;
                                });
                              } else {
                                Fluttertoast.showToast(msg: 'pleaseAddress'.tr);
                              }
                            }
                          },
                          height: 45,
                          minWidth: 100,
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
            Text(
              'shipping'.tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            auth.userData.address!.isEmpty
                ? MaterialButton(
                    minWidth: 0,
                    height: 25,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    onPressed: () async {
                      await Navigator.pushNamed(context, 'address');
                      setState(() {});
                    },
                    shape: const RoundedRectangleBorder(
                        side: BorderSide(),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Text(
                      'addNew'.tr,
                      style:
                          TextStyle(fontSize: 12, color: Colors.amber.shade700),
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
                      shape: const RoundedRectangleBorder(
                          side: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Text(
                        'change'.tr,
                        style:
                            TextStyle(fontSize: 12, color: Colors.red.shade700),
                      ),
                    ),
                  ),
            const Divider(
              color: Colors.grey,
            ),
            Text(
              'Payment methods'.tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            // Container(
            //   decoration: BoxDecoration(
            //       borderRadius: const BorderRadius.all(Radius.circular(25)),
            //       color: Colors.grey.shade200),
            //   child: Row(
            //     children: [
            //       Flexible(
            //         child: TextField(
            //           controller: code,
            //           decoration: InputDecoration(
            //               hintText: 'promo'.tr,
            //               enabledBorder: const OutlineInputBorder(
            //                 borderSide: BorderSide(color: Colors.transparent),
            //               ),
            //               focusedBorder: const OutlineInputBorder(
            //                 borderSide: BorderSide(color: Colors.transparent),
            //               ),
            //               border: const OutlineInputBorder(
            //                 borderSide: BorderSide(color: Colors.transparent),
            //               ),
            //               contentPadding:
            //                   const EdgeInsets.symmetric(horizontal: 15)),
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 10),
            //         child: loading
            //             ? const CircularProgressIndicator()
            //             : MaterialButton(
            //                 textColor: Colors.white,
            //                 onPressed: () async {
            //                   setState(() {
            //                     loading = true;
            //                   });

            //                   await firestore
            //                       .collection('coupons')
            //                       .where('code', whereIn: [
            //                         code.text.toLowerCase(),
            //                         code.text.toUpperCase()
            //                       ])
            //                       .get()
            //                       .then((value) {
            //                         if (value.size > 0) {
            //                           couponData = CouponModel.fromJson(
            //                               value.docs.first.data());

            //                           if (couponData.endTime!
            //                               .isBefore(DateTime.now())) {
            //                             Fluttertoast.showToast(
            //                                 msg: 'expired'.tr);
            //                             couponData = CouponModel();
            //                           }
            //                         } else {
            //                           couponData = CouponModel();
            //                           Fluttertoast.showToast(msg: 'noCode'.tr);
            //                         }
            //                       });
            //                   setState(() {
            //                     loading = false;
            //                   });
            //                 },
            //                 color: appConstant.primaryColor,
            //                 height: 40,
            //                 shape: const RoundedRectangleBorder(
            //                     borderRadius:
            //                         BorderRadius.all(Radius.circular(25))),
            //                 child: Text('apply'.tr),
            //               ),
            //       )
            //     ],
            //   ),
            // ),
            if (paymob!.id.isNotEmpty)
              Column(
                children: auth.appData!.paymobs!
                    .where((w) => w.status)
                    .map((m) => RadioListTile(
                          activeColor: appConstant.primaryColor,
                          contentPadding: EdgeInsets.zero,
                          value: m,
                          onChanged: (value) {
                            setState(() {
                              paymob = m;
                            });
                          },
                          groupValue: paymob,
                          title: Text(m.name),
                        ))
                    .toList(),
              ),
            if (couponData.id.isNotEmpty)
              ListTile(
                title: Text(couponData.titleEn),
                trailing: Text('${couponData.discount}%'),
                subtitle: Text(
                    '${'upTo'.tr} ${couponData.max.toStringAsFixed(2)} ${'AED'.tr}'),
              ),
            const Divider(
              color: Colors.grey,
            ),
            Text(
              'orderList'.tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: userController.cartList.length,
                itemBuilder: (context, index) {
                  CartModel cart =
                      userController.cartList.values.toList()[index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: CachedNetworkImage(
                        imageUrl: cart.productData!.media![0],
                        width: 75,
                        height: 75,
                        fit: BoxFit.cover,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetails(product: cart.productData!),
                          ));
                    },
                    title: Text(
                      cart.productData!.titleEn,
                      overflow: TextOverflow.ellipsis,
                    ),
                    visualDensity: const VisualDensity(vertical: 4),
                    subtitle: Text(
                      '${'AED'.tr} ${cart.productData!.price}',
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
