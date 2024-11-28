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
          "클컴 팀플",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,

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
                    "팀 소개",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "우리는 클라우드 컴퓨팅 프로젝트를 진행하는 팀입니다.\n"
                        "프로그램을 통해 스타일 변환과 관련된 다양한 기능을 제공합니다.",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),

          // 팀원 소개 - 토글 기능
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: ExpansionTile(
              title: Text(
                "팀원 소개",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              children: [
                ListTile(
                  title: Text(
                    "1. 팀원 A",
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Text("역할: 백엔드 개발\n특기: Flask, FastAPI"),
                ),
                ListTile(
                  title: Text(
                    "2. 팀원 B",
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Text("역할: 프론트엔드 개발\n특기: Flutter, UI 디자인"),
                ),
                ListTile(
                  title: Text(
                    "3. 팀원 C",
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Text("역할: 프로젝트 매니저\n특기: 문서 작성, 일정 관리"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 50), // 공간 추가

          // 버튼을 1/3 지점으로 내리기 위한 Spacer
          const Spacer(flex: 1),

          // 버튼
          ElevatedButton(
            onPressed: () {
              Get.to(const GenPage());
            },
            child: const Text("이미지 변환"),
          ),

          // Spacer를 통해 남은 공간 조정
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
