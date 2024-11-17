import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

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

  /*Future<void> _genButtonClick() async {
    dio.options.baseUrl = "http://3.210.19.76:8080";

    if (_styleImage == null || _sourceImage == null) {
      print('스타일 이미지와 콘텐츠 이미지를 모두 선택해주세요.');
      return;
    }

    final styleData = _styleImage!.path;
    final sourceData = _sourceImage!.path;

    final formData = FormData.fromMap({
      "content_image": await MultipartFile.fromFile(
        sourceData,
      ),
      "style_image": await MultipartFile.fromFile(
        styleData,
      ),
    });

    try {
      final response = await dio.post('/images', data: formData);
      print('업로드 성공: $response');
    } on DioException catch (e) {
      print('오류 발생: ${e.response?.statusCode}');
      print('오류 내용: ${e.response?.data}');
    }
  }*/

  /*Future<void> _genButtonClick() async {
    final url = Uri.parse('http://3.210.19.76:8080/images');
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('content_image', _sourceImage!.path))
      ..files.add(await http.MultipartFile.fromPath('style_image', _styleImage!.path));

    try {
      final response = await request.send();
      print("리스폰스!!!!:${response}");
    } catch (e) {
      print("에러!!!!!!!!!!: $e");
    }

  }*/

  Future<void> _genButtonClick() async {
    final url = Uri.parse('http://3.210.19.76:8080/images');

    String source64 = base64Encode(await _sourceImage!.readAsBytes());
    String style64 = base64Encode(await _styleImage!.readAsBytes());
    Map data = {
      'content_image': source64,
      'style_image': style64,
      'alpha':alpha,
    };
    var body = json.encode(data);

    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: body
      );
      print("리스폰스!!!!:${response}");
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

          ElevatedButton(
            onPressed: _genButtonClick,
            child: const Text("Generate"),
          )
        ],
      ),
    );
  }
}
