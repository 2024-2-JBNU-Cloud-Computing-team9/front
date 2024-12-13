import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
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
  String? _source64;
  String? _style64;
  Uint8List? _styleBytes;

  final dio = Dio();
  double alpha = 0.5;
  bool _wait = false;

  final _genMenu = ["내 기기","Lambda", "EC2"];
  String? _selectedMenu = '';

  final List<Map<String, dynamic>>_styles = [
    {"image":"assets/images/styles/blueMountain.jpg"},
    {"image":"assets/images/styles/Ocean.jpg"},
    {"image":"assets/images/styles/sky.jpeg"},
    {"image":"assets/images/styles/sunset.jpg"},
    {"image":"assets/images/styles/wheat.jpg"},
    {"image":"assets/images/styles/yellowMaple.jpg"},
    {"image":"assets/images/gallery.png", "gallery":true},
  ];

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
      _source64 = base64Encode(await image.readAsBytes());
      setState(() {
        _sourceImage;
      });
    }
  }

  Future<void> _getStyleImage() async {
    Get.bottomSheet(
        ListView(
          children: [
            const SizedBox(height: 20,),
            GridView.builder(
              shrinkWrap: true,
                gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemCount: _styles.length,
                itemBuilder: (context, index){
                  return GestureDetector(
                    onTap: (){
                      selectStyleImage(index);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.grey)
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.asset("${_styles[index]['image']}",
                              fit: BoxFit.cover,),
                          ),
                          if (_styles[index].containsKey("gallery"))
                            const Text("갤러리에서 찾기"),
                        ],
                      ),
                    ),
                  );
                }
            ),
          ],
        ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
    );

  }

  Future<void> selectStyleImage(int index) async {
    if (_styles[index].containsKey("gallery")) {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (image != null) {
        _styleImage = image;
        _styleBytes = await image.readAsBytes();
        _style64 = base64Encode(await image.readAsBytes());
        setState(() {
          _styleBytes;
        });
      }
      Get.back();
    }
    else{
      final bytes = await rootBundle.load("${_styles[index]['image']}");
      _styleBytes = bytes.buffer.asUint8List();
      _style64 = base64Encode(bytes.buffer.asUint8List());
      setState(() {
        _styleBytes;
      });
      Get.back();
    }
  }

  Future<void> _genButtonClick() async {
    final url = Uri.parse('http://44.212.129.143:8080/images');
    Map data = {
      'content_image': _source64,
      'style_image': _style64,
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
      Get.snackbar("에러", "$e");
      setState(() {
        _wait = false;
      });

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
                          child: Text("변환할 이미지 선택",
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
                  child: _styleBytes == null ?
                  const Center(
                      child: Text("스타일 이미지 선택",
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      )
                  )  :
                  ClipRect(
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 10-alpha*10, sigmaY: 10-alpha*10),
                        child: Image.memory(_styleBytes!,fit: BoxFit.fitWidth,)
                    ),
                  ),
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

          // ElevatedButton(
          //   onPressed: test,
          //   child: const Text("test"),
          // ),
        ],
      ),
    );
  }
}
