import 'package:flutter/material.dart';

class MainScreenTemplate extends StatefulWidget {
  final Widget children;
  const MainScreenTemplate({Key? key, required this.children})
      : super(key: key);

  @override
  State<MainScreenTemplate> createState() => _MainScreenTemplateState();
}

class _MainScreenTemplateState extends State<MainScreenTemplate> {
  final Color mainColor = const Color(0xFFE32321);
  final Color darkerColor = const Color(0xFF7D1312);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.motorcycle, color: Colors.white),
                SizedBox(width: 8),
                Text('Bidlotto', style: TextStyle(color: Colors.white)),
              ],
            ),
            Icon(Icons.person, color: Colors.white),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [mainColor, darkerColor],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: const Column(
                  children: [
                    Text(
                      'บิดก่อนได้เปรียบลอตเตอรี่',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'ชุดใหญ่ รับไว ไม่โอนคืน',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child:
                      Container()), // This will push the content to the bottom
            ],
          ),
          Positioned(
            top: 120,
            left: 8,
            right: 8,
            bottom: 0,
            child: SingleChildScrollView(child: widget.children),
          )
        ],
      ),
    );
  }
}
