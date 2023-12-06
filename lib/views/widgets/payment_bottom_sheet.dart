// ignore_for_file: use_build_context_synchronously

import 'package:believer/controller/app_localization.dart';
import 'package:believer/controller/my_app.dart';
import 'package:believer/views/screens/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class BottomSheetPayment extends StatefulWidget {
  const BottomSheetPayment({super.key});

  @override
  State<BottomSheetPayment> createState() => _BottomSheetPaymentState();
}

class _BottomSheetPaymentState extends State<BottomSheetPayment> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false, loading = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  submit() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });

    await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update({
      'wallet': FieldValue.arrayUnion([
        {
          'name': cardHolderName,
          'number': cardNumber,
          'date': expiryDate,
        }
      ])
    });

    await auth.getUserData();
    setState(() {
      loading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        const Center(
          child: Text(
            'Add new card',
            style: TextStyle(fontSize: 25),
          ),
        ),
        Flexible(
          child: ListView(
            controller: staticWidgets.scrollController,
            children: [
              CreditCardWidget(
                cardBgColor: primaryColor,
                enableFloatingCard: true,
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                obscureCardCvv: true,
                isHolderNameVisible: true,
                onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
              ),
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CreditCardForm(
                      formKey: formKey,
                      obscureCvv: true,
                      obscureNumber: true,
                      cardNumber: cardNumber,
                      cvvCode: cvvCode,
                      cardHolderName: cardHolderName,
                      expiryDate: expiryDate,
                      inputConfiguration: const InputConfiguration(
                        cardNumberDecoration: InputDecoration(
                          labelText: 'Number',
                          hintText: 'XXXX XXXX XXXX XXXX',
                        ),
                        expiryDateDecoration: InputDecoration(
                          labelText: 'Expired Date',
                          hintText: 'XX/XX',
                        ),
                        cvvCodeDecoration: InputDecoration(
                          labelText: 'CVV',
                          hintText: 'XXX',
                        ),
                        cardHolderDecoration: InputDecoration(
                          labelText: 'Card Holder',
                        ),
                      ),
                      onCreditCardModelChange: onCreditCardModelChange,
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 20),
                child: loading
                    ? const CircularProgressIndicator()
                    : MaterialButton(
                        minWidth: 100,
                        height: 40,
                        onPressed: () async {
                          submit();
                        },
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        color: primaryColor,
                        child: Text(
                          'submit'.tr(context),
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                      ),
              )
            ],
          ),
        )
      ],
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
