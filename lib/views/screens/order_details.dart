import 'package:believer/controller/app_localization.dart';
import 'package:believer/controller/my_app.dart';
import 'package:believer/models/order_model.dart';
import 'package:believer/models/product_model.dart';
import 'package:believer/views/widgets/app_bar.dart';
import 'package:believer/views/widgets/review_bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key, required this.order});
  final OrderModel order;

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  OrderModel order = OrderModel();

  fetch() async {
    await firestore
        .collection('orders')
        .doc(order.timestamp!.millisecondsSinceEpoch.toString())
        .get()
        .then((value) {
      order = OrderModel.fromJson(value.data() as Map);
      setState(() {});
    });
  }

  @override
  void initState() {
    order = widget.order;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        action: !order.rated && order.status == 'complete'
            ? {
                'icon': Icons.star,
                'function': () async {
                  await staticWidgets.showBottom(
                      context,
                      BottomSheetReview(
                        id: order.timestamp!.millisecondsSinceEpoch.toString(),
                      ),
                      0.5,
                      0.75);
                  fetch();
                }
              }
            : {},
        title: '#${order.number}',
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
            height: 130,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${'subtotal'.tr(context)}:'),
                    Text(
                      '${'AED'.tr(context)} ${order.total.toStringAsFixed(2)}',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${'deliveryFee'.tr(context)}:'),
                    Text(
                      '${'AED'.tr(context)} ${order.delivery}',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${'discount'.tr(context)}:'),
                    Text(
                      '${order.discount}%',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${'total'.tr(context)}:'),
                    Text(
                      '${'AED'.tr(context)} ${(order.total - (order.total * (order.discount / 100)) + order.delivery).toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ],
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
        ),
        child: RefreshIndicator(
          color: primaryColor,
          onRefresh: () async {
            fetch();
          },
          child: ListView(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('orderNumber'.tr(context)),
                Text(order.number.toString())
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('name'.tr(context)), Text(order.name)],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('phone'.tr(context)),
                Text(order.addressData!.phone)
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('address'.tr(context)),
                Text(order.addressData!.address)
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('orderT&D'.tr(context)),
                Text(DateFormat('dd/MM/yyyy hh:mm a').format(order.timestamp!))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('status'.tr(context)),
                Text(order.status.tr(context))
              ],
            ),
            const Divider(
              color: Colors.grey,
            ),
            Text(
              'orderList'.tr(context),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) => const Divider(),
              itemCount: order.orderList!.length,
              itemBuilder: (context, index) {
                ProductModel orderList = order.orderList![index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: CachedNetworkImage(
                      imageUrl: orderList.media![0],
                      width: 75,
                      height: 75,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    locale.locale == 'ar'
                        ? orderList.titleAr
                        : orderList.titleEn,
                    overflow: TextOverflow.ellipsis,
                  ),
                  visualDensity: const VisualDensity(vertical: 4),
                  subtitle: Text(
                    '${'AED'.tr(context)} ${orderList.price}',
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}
