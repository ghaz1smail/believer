import 'package:believer/controller/app_localization.dart';
import 'package:believer/controller/my_app.dart';
import 'package:believer/models/user_model.dart';
import 'package:believer/views/screens/splash_screen.dart';
import 'package:believer/views/widgets/app_bar.dart';
import 'package:believer/views/widgets/payment_bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int i = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: 'paymentMethod'.tr(context),
        action: {
          'icon': Icons.add,
          'function': () async {
            await staticWidgets.showBottom(
                context, const BottomSheetPayment(), 0.8, 0.9);
            setState(() {});
          }
        },
      ),
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: () async {
          await auth.getUserData();
          setState(() {});
        },
        child: auth.userData.wallet!.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/empty_data.png',
                      height: 150,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'noPayment'.tr(context),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              )
            : ListView.builder(
                itemCount: auth.userData.wallet!.length,
                itemBuilder: (context, index) {
                  var e = auth.userData.wallet![index];
                  return Row(
                    children: [
                      Flexible(
                        child: CreditCardWidget(
                          padding: 10,
                          height: 125,
                          isSwipeGestureEnabled: false,
                          isChipVisible: false,
                          cardBgColor: primaryColor,
                          enableFloatingCard: true,
                          cardNumber: e.number,
                          expiryDate: e.date,
                          cardHolderName: e.name,
                          cvvCode: '',
                          showBackView: false,
                          obscureCardCvv: true,
                          isHolderNameVisible: true,
                          onCreditCardWidgetChange:
                              (CreditCardBrand creditCardBrand) {},
                        ),
                      ),
                      if (index != i)
                        Column(
                          children: [
                            if (index == 0)
                              Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Text(
                                    'default'.tr(context),
                                    style: const TextStyle(fontSize: 10),
                                  )),
                            IconButton(
                                onPressed: () async {
                                  setState(() {
                                    i = index;
                                  });
                                  await firestore
                                      .collection('users')
                                      .doc(firebaseAuth.currentUser!.uid)
                                      .update({
                                    'wallet': FieldValue.arrayRemove([
                                      {
                                        'name': e.name,
                                        'number': e.number,
                                        'date': e.date
                                      }
                                    ])
                                  });
                                  await auth.getUserData();
                                  setState(() {
                                    i = -1;
                                  });
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                            IconButton(
                                onPressed: () async {
                                  var d = auth.userData.wallet;
                                  setState(() {
                                    i = index;
                                  });
                                  d!.removeAt(index);
                                  d.insert(
                                      0,
                                      WalletModel(
                                        name: e.name,
                                        date: e.date,
                                        number: e.number,
                                      ));

                                  await firestore
                                      .collection('users')
                                      .doc(firebaseAuth.currentUser!.uid)
                                      .update({
                                    'wallet': d.map((e) => {
                                          'name': e.name,
                                          'number': e.number,
                                          'date': e.date
                                        })
                                  });
                                  await auth.getUserData();
                                  setState(() {
                                    i = -1;
                                  });
                                },
                                icon: const Icon(Icons.edit))
                          ],
                        )
                    ],
                  );
                }),
      ),
    );
  }
}
