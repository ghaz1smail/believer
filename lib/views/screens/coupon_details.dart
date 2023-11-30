import 'package:believer/models/coupon_model.dart';
import 'package:believer/views/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class CouponDetails extends StatefulWidget {
  const CouponDetails({super.key, required this.coupon});
  final CouponModel coupon;

  @override
  State<CouponDetails> createState() => _CouponDetailsState();
}

class _CouponDetailsState extends State<CouponDetails> {
  bool loading = false;
  updateData() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: widget.coupon.descriptionEn,
        action: {
          'function': updateData,
          'icon': widget.coupon.id.isEmpty ? Icons.add : Icons.edit
        },
        loading: loading,
      ),
    );
  }
}
