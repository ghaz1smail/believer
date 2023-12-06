import 'package:believer/controller/app_localization.dart';
import 'package:believer/controller/my_app.dart';
import 'package:believer/models/cart_model.dart';
import 'package:believer/models/coupon_model.dart';
import 'package:believer/models/order_model.dart';
import 'package:believer/views/screens/order_details.dart';
import 'package:believer/views/screens/splash_screen.dart';
import 'package:believer/views/screens/user_screen.dart';
import 'package:believer/views/widgets/app_bar.dart';
import 'package:believer/views/widgets/payment_bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool makeOrder = false, loading = false;
  CouponModel couponData = CouponModel();
  TextEditingController code = TextEditingController();

  ordering() async {
    Fluttertoast.showToast(msg: 'orderPlaced'.tr(context));
    var id = DateTime.now(), numbbers = 0;
    await firestore.collection('orders').get().then((value) {
      numbbers = value.size;
    });

    var data = {
      'number': numbbers + 1,
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
      'orderList': userCubit.cartList.entries
          .map((e) => {
                'id': e.key,
                'titleEn': e.value.productData!.titleEn,
                'titleAr': e.value.productData!.titleAr,
                'price': e.value.productData!.price,
                'media': [e.value.productData!.media!.first],
                'count': e.value.count,
              })
          .toList()
    };
    firestore
        .collection('orders')
        .doc(id.millisecondsSinceEpoch.toString())
        .set(data);
    navigatorKey.currentState?.pushReplacement(MaterialPageRoute(
      builder: (context) => OrderDetails(order: OrderModel.fromJson(data)),
    ));
    userCubit.clearCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Container(
            height: 150,
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
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${'subtotal'.tr(context)}:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: couponData.id.isNotEmpty
                                  ? TextDecoration.lineThrough
                                  : null),
                        ),
                        Text(
                            '${'AED'.tr(context)} ${userCubit.totalCartPrice().toStringAsFixed(2)}',
                            style: const TextStyle()),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${'deliveryFee'.tr(context)}:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: couponData.id.isNotEmpty
                                  ? TextDecoration.lineThrough
                                  : null),
                        ),
                        Text('${'AED'.tr(context)} 25',
                            style: const TextStyle()),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${'discount'.tr(context)}:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: couponData.id.isNotEmpty
                                  ? TextDecoration.lineThrough
                                  : null),
                        ),
                        Text(
                            '-${'AED'.tr(context)} ${(((userCubit.totalCartPrice() * (couponData.discount / 100)) > couponData.max ? couponData.max : (userCubit.totalCartPrice() * (couponData.discount / 100)))).toStringAsFixed(2)}',
                            style: const TextStyle()),
                      ]),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${'total'.tr(context)}:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: couponData.id.isNotEmpty
                                ? TextDecoration.lineThrough
                                : null),
                      ),
                      Text(
                          '${'AED'.tr(context)} ${(userCubit.totalCartPrice() - ((userCubit.totalCartPrice() * (couponData.discount / 100)) > couponData.max ? couponData.max : (userCubit.totalCartPrice() * (couponData.discount / 100))) + 25).toStringAsFixed(2)}'),
                    ],
                  ),
                  makeOrder
                      ? const CircularProgressIndicator()
                      : MaterialButton(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          onPressed: () async {
                            if (auth.userData.address!.isNotEmpty) {
                              // setState(() {
                              //   makeOrder = true;
                              // });

                              // await staticFunctions.makePayment(
                              //     (userCubit.totalCartPrice() -
                              //         ((userCubit.totalCartPrice() *
                              //             (couponData.discount / 100))) +
                              //         25.0),
                              //     ordering);

                              staticWidgets.showBottom(context,
                                  const BottomSheetPayment(), 0.85, 0.9);
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'pleaseAddress'.tr(context));
                            }
                          },
                          height: 45,
                          minWidth: 100,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          color: primaryColor,
                          textColor: Colors.white,
                          child: Text('placeOrder'.tr(context)),
                        ),
                ])),
      ),
      appBar: AppBarCustom(
        title: 'CHECKOUT'.tr(context),
        action: const {},
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            auth.userData.address!.isEmpty
                ? Align(
                    child: MaterialButton(
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
                        'addNew'.tr(context),
                        style:
                            TextStyle(fontSize: 12, color: Colors.red.shade700),
                      ),
                    ),
                  )
                : ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.location_on,
                      color: primaryColor,
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
                        'change'.tr(context),
                        style: TextStyle(
                            fontSize: 12, color: Colors.amber.shade700),
                      ),
                    ),
                  ),
            const Divider(
              color: Colors.grey,
            ),
            Text(
              'orderList'.tr(context),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: userCubit.cartList.length,
                itemBuilder: (context, index) {
                  CartModel cart = userCubit.cartList.values.toList()[index];
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
                    title: Text(
                      cart.productData!.titleEn,
                      overflow: TextOverflow.ellipsis,
                    ),
                    visualDensity: const VisualDensity(vertical: 4),
                    subtitle: Text(
                      '${'AED'.tr(context)} ${cart.productData!.price}',
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  color: Colors.grey.shade200),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: code,
                      decoration: InputDecoration(
                          hintText: 'promo'.tr(context),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: loading
                        ? const CircularProgressIndicator()
                        : MaterialButton(
                            textColor: Colors.white,
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
                                            msg: 'expired'.tr(context));
                                        couponData = CouponModel();
                                      }
                                    } else {
                                      couponData = CouponModel();
                                      Fluttertoast.showToast(
                                          msg: 'noCode'.tr(context));
                                    }
                                  });
                              setState(() {
                                loading = false;
                              });
                            },
                            color: primaryColor,
                            height: 40,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            child: Text('apply'.tr(context)),
                          ),
                  )
                ],
              ),
            ),
            if (couponData.id.isNotEmpty)
              ListTile(
                title: Text(couponData.titleEn),
                trailing: Text('${couponData.discount}%'),
                subtitle: Text(
                    '${'upTo'.tr(context)} ${couponData.max.toStringAsFixed(2)} ${'AED'.tr(context)}'),
              ),
          ],
        ),
      ),
    );
  }
}
