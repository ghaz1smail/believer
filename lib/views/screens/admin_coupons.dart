import 'package:believer/controller/my_app.dart';
import 'package:believer/models/coupon_model.dart';
import 'package:believer/views/screens/coupon_details.dart';
import 'package:believer/views/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:ticket_widget/ticket_widget.dart';

class AdminCoupons extends StatefulWidget {
  const AdminCoupons({super.key});

  @override
  State<AdminCoupons> createState() => _AdminCouponsState();
}

class _AdminCouponsState extends State<AdminCoupons> {
  TextEditingController search = TextEditingController();
  Iterable<CouponModel> result = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: 'Coupons', action: {
        'icon': Icons.add,
        'function': () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CouponDetails(
                    coupon: CouponModel(descriptionEn: 'New coupon')),
              ));
          setState(() {});
        }
      }),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: firestore.collection('coupons').get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<CouponModel> data = snapshot.data!.docs
                  .map((e) => CouponModel.fromJson(e.data()))
                  .toList();
              result = data.where((a) =>
                  a.code.toLowerCase().contains(search.text.toLowerCase()));

              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    CupertinoSearchTextField(
                      controller: search,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    Expanded(
                      child: result.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/no_result.png'),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text('No data found')
                              ],
                            )
                          : ListView.builder(
                              itemCount: result.length,
                              itemBuilder: (context, index) {
                                CouponModel coupon = result.toList()[index];
                                return GestureDetector(
                                  onTap: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CouponDetails(
                                            coupon: coupon,
                                          ),
                                        ));
                                    setState(() {});
                                  },
                                  child: TicketWidget(
                                    width: dWidth,
                                    height: 150,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    color: primaryColor,
                                    isCornerRounded: true,
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Text('data'),
                                            IconButton(
                                              onPressed: () {},
                                              icon: const Icon(Icons.copy),
                                            )
                                          ],
                                        ),
                                        const Text('data'),
                                        const Row(
                                          children: [
                                            Icon(BoxIcons.bxs_offer),
                                            Text('data'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
