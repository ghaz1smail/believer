import 'package:believer/controller/my_app.dart';
import 'package:believer/models/cart_model.dart';
import 'package:believer/views/screens/splash_screen.dart';
import 'package:believer/views/screens/user_screen.dart';
import 'package:believer/views/widgets/app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String payment = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(
        title: 'CHECKOUT',
        action: {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shipping address',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.location_on,
                color: primaryColor,
              ),
              title: Text(auth.userData.address!.first['name']),
              subtitle: Text(auth.userData.address!.first['address']),
              trailing: MaterialButton(
                minWidth: 0,
                height: 25,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                onPressed: () {
                  Navigator.pushNamed(context, 'address');
                },
                shape: const RoundedRectangleBorder(
                    side: BorderSide(),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Text(
                  'Change',
                  style: TextStyle(fontSize: 12, color: Colors.amber.shade700),
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),
            const Text(
              'Payment methods',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            RadioListTile(
              contentPadding: EdgeInsets.zero,
              value: 'card',
              groupValue: payment,
              onChanged: (v) async {
                await staticFunctions.makePayment();
                // setState(() {
                //   payment = v.toString();
                // });
              },
              activeColor: primaryColor,
              title: const Text('Credit/Debit card'),
            ),
            RadioListTile(
              contentPadding: EdgeInsets.zero,
              value: 'cash',
              groupValue: payment,
              activeColor: primaryColor,
              onChanged: (v) {
                setState(() {
                  payment = v.toString();
                });
              },
              title: const Text('Cash on delivery'),
            ),
            const Divider(
              color: Colors.grey,
            ),
            const Text(
              'Order list',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
                      'AED ${cart.productData!.price}',
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
