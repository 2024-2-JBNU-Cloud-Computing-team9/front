import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jbnu_cloud_computing_project/pages/genPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: 'Cloud Computing Project',

      home: GenPage()
    );
  }
}
