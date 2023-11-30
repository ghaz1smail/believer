import 'package:believer/controller/my_app.dart';
import 'package:flutter/material.dart';

class Counter extends StatelessWidget {
  const Counter(
      {super.key,
      required this.remove,
      required this.add,
      required this.other,
      this.count = 0});
  final Function remove, add, other;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            if (count > 1) {
              remove();
            } else {
              other();
            }
          },
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: const Icon(
              Icons.remove,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
        Text(
          count.toString(),
          style: const TextStyle(color: Colors.black),
        ),
        InkWell(
          onTap: () {
            add();
          },
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
