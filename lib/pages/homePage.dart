import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jbnu_cloud_computing_project/pages/genPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "  클컴 팀플",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,

      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 모서리 둥근 박스: 팀 소개
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "앱 소개",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    " 콘텐츠 이미지와 스타일 이미지를 결합해 원하는 감성의 새로운 이미지를 생성하는 앱입니다.\n 클라우드 컴퓨팅을 활용해 빠르고 고품질의 이미지 처리를 제공하며, 누구나 간편하게 나만의 예술 작품을 만들 수 있습니다.",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),

          // 팀원 소개 - 토글 기능
          const SizedBox(
            height: 400,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: ExpansionTile(
                title: Text(
                  "팀원 소개",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  ListTile(
                    title: Text(
                      "박건",
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Text("역할 : 프론트엔드, 발표, 테스트 \n학번 : 20192307"),
                  ),
                  ListTile(
                    title: Text(
                      "최현우",
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Text("역할 : 모델 구현, 백엔드\n학번 : 202011591"),
                  ),
                  ListTile(
                    title: Text(
                      "정태우",
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Text("역할 : 백엔드\n학번 : 202212251"),
                  ),
                  ListTile(
                    title: Text(
                      "김민재",
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Text("역할 : 프론트엔드, PPT\n학번 : 202212097"),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10), // 공간 추가


          // 버튼
          ElevatedButton(
            onPressed: () {
              Get.to(const GenPage());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              minimumSize: const Size(150, 40)
            ),
            child: const Text("시작", style: TextStyle(fontSize: 18),),
          ),

        ],
      ),
    );
  }
}
