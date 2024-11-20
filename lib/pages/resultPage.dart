

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image.memory(bytes),
      ),
    );
  }
}
