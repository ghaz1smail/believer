import 'package:believer/views/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: AppBarCustom(
      title: 'Address',
      action: {},
    ));
  }
}
