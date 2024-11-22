import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:jbnu_cloud_computing_project/pages/resultPage.dart';

class GenPage extends StatefulWidget {
  const GenPage({super.key});

  @override
  State<GenPage> createState() => _GenPageState();
}

class _GenPageState extends State<GenPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _sourceImage;
  XFile? _styleImage;
  final dio = Dio();
  double alpha = 0.5;
  bool _wait = false;

  final _genMenu = ["내 기기","Lambda", "EC2"];
  String? _selectedMenu = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedMenu = _genMenu[0];
    });
  }

  Future<void> _getSourceImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery,);
    if(image != null){
      _sourceImage = image;
      setState(() {
        _sourceImage;
      });
    }
  }

  Future<void> _getStyleImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery,);
    if(image != null){
      _styleImage = image;
      setState(() {
        _styleImage;
      });
    }
  }


  Future<void> _genButtonClick() async {
    final url = Uri.parse('http://54.225.194.185:8080/images');

    String source64 = base64Encode(await _sourceImage!.readAsBytes());
    String style64 = base64Encode(await _styleImage!.readAsBytes());
    Map data = {
      'content_image': source64,
      'style_image': style64,
      'alpha':alpha,
    };
    var body = json.encode(data);

    try {
      setState(() {
        _wait = true;
      });
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: body,
      );
      setState(() {
        _wait = false;
      });
      final responsJson = jsonDecode(response.body);
      final img64 = responsJson['output_image'].toString();
      Get.to(ResultPage(img64: img64));
    } catch (e) {
      print("에러!!!!!!!!!!: $e");
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "클컴 팀플",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: [
          DropdownButton(
            value: _selectedMenu,
            items: _genMenu.map(
                    (e)=>DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    )).toList(),
            onChanged: (value){
              setState(() {
                _selectedMenu = value;
              });
            },
          )

        ],
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(

                onTap: _getSourceImage,
                child: Container(
                  height: Get.height/4,
                  width: Get.width/2,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 2
                    )
                  ),
                  child: _sourceImage == null ?
                      const Center(
                          child: Text("Select Content Image",
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          )
                      ) :
                      Image.file(File(_sourceImage!.path)),

                ),
              ),
              GestureDetector(
                onTap: _getStyleImage,
                child: Container(
                  height: Get.height/4,
                  width: Get.width/2,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey,
                          width: 2
                      )
                  ),
                  child: _styleImage == null ?
                  const Center(
                      child: Text("Select Style Image",
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      )
                  )  :
                  Image.file(File(_styleImage!.path)),
                ),
              ),
            ],
          ),


          Slider(
            value: alpha,
            max: 1,
            label: alpha.toString(),
            divisions: 10,
            onChanged: (value){
              setState(() {
                alpha = value;
              });
            },
          ),

          _wait ? const CircularProgressIndicator() :
          ElevatedButton(
            onPressed: _genButtonClick,
            child: const Text("Generate"),
          ),
        ],
      ),
    );
  }
}
