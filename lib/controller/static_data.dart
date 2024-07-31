import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class StaticData {
  String adminUID = 'Ms4bgI9hdCUfLQF9Bf52lXAb0P43';

  String formatElapsedTime(time, context) {
    var currentTime = DateTime.now().toUtc();
    var convertTime = DateTime.parse(time).toUtc();

    if (currentTime.isBefore(convertTime)) {
      final temp = currentTime;
      currentTime = convertTime;
      convertTime = temp;
    }

    final elapsedDuration = currentTime.difference(convertTime);

    if (elapsedDuration.inDays >= 365) {
      final years = (elapsedDuration.inDays / 365).floor();
      return '$years${years > 1 ? ' ${'years'.tr}' : ' ${'year'.tr}'}';
    } else if (elapsedDuration.inDays >= 30) {
      final months = (elapsedDuration.inDays / 30.44).floor();
      return '$months${months > 1 ? ' ${'months'.tr}' : ' ${'month'.tr}'}';
    } else if (elapsedDuration.inDays >= 7) {
      final weeks = (elapsedDuration.inDays / 7).floor();
      return '$weeks${weeks > 1 ? ' ${'weekss'.tr}' : ' ${'weeks'.tr}'}';
    } else if (elapsedDuration.inDays > 0) {
      return '${elapsedDuration.inDays}${elapsedDuration.inDays > 1 ? ' ${'days'.tr}' : ' ${'day'.tr}'}';
    } else if (elapsedDuration.inHours > 0) {
      return '${elapsedDuration.inHours}${'h'.tr}';
    } else if (elapsedDuration.inMinutes > 0) {
      return '${elapsedDuration.inMinutes}${'m'.tr}';
    } else {
      return '${elapsedDuration.inSeconds}${'s'.tr}';
    }
  }

  List<Map> bottomBar = [
    {'home': Iconsax.home_2_bold},
    {'wishlist': IonIcons.heart_half},
    {'cart': EvaIcons.shopping_bag},
    {'profile': Icons.person},
  ];
}
