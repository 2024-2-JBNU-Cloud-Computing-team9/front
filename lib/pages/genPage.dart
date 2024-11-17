import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';

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
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if(image != null){
      _sourceImage = image;
      setState(() {
        _sourceImage;
      });
    }
  }

  Future<void> _getStyleImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if(image != null){
      _styleImage = image;
      setState(() {
        _styleImage;
      });
    }
  }

  Future<void> _genButtonClick()async{
    dio.options.baseUrl = "https://xat9ent0p7.execute-api.us-east-1.amazonaws.com/stage";
    dynamic styleData = _styleImage!.path;
    dynamic sourceData = _sourceImage!.path;
    dynamic type = _sourceImage!.runtimeType;
    print("타입!!:$type");
    final formData = FormData.fromMap({
      "content_image": await MultipartFile.fromFile(sourceData),
      "style_image": await MultipartFile.fromFile(styleData),
    });
    try {
      final response = await dio.post('/images', data: formData);
    }catch(e){
      print('에러어어어어어어: $e');
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
                      const Icon(Icons.image) :
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
                  const Icon(Icons.image) :
                  Image.file(File(_styleImage!.path)),
                ),
              ),
            ],
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
