

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';

class ResultPage extends StatefulWidget {
  final String img64;
  const ResultPage({required this.img64,super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {

  @override
  Widget build(BuildContext context) {
    final Uint8List bytes = const Base64Decoder().convert(widget.img64);

    Future<void> saveImage() async {
      await Gal.putImageBytes(bytes);
      Get.snackbar("이미지 저장", "이미지를 저장했습니다.");
    }

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: saveImage,
                child: const Icon(Icons.file_download),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,

                ),
              )
            ],
          ),
          Center(
            child: Image.memory(bytes),
          ),
        ],
      ),
    );
  }
}
