import 'package:believer/controller/my_app.dart';
import 'package:believer/get_initial.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await GetInitial().initialApp();

  runApp(const MyApp());
}
