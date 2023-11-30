import 'package:believer/controller/my_app.dart';
import 'package:believer/views/widgets/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NImage extends StatelessWidget {
  const NImage(
      {super.key, required this.url, required this.h, this.fit = BoxFit.fill});
  final String url;
  final double h;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: url,
        height: h,
        fit: fit,
        errorWidget: (context, url, progress) => const Center(
              child: Icon(Icons.error),
            ),
        progressIndicatorBuilder: (context, url, progress) => Shimmers(
              child: Container(
                height: h,
                color: primaryColor,
              ),
            ));
  }
}
