import 'package:flutter/material.dart';

class HomeValidate extends StatefulWidget {
  const HomeValidate({super.key});

  @override
  State<HomeValidate> createState() => _HomeValidateState();
}

class _HomeValidateState extends State<HomeValidate> {
  int _selectedIndex = 0;
  final Color mainColor = const Color(0xFFE32321);
  final Color darkerColor = const Color(0xFF7D1312);
  final TextEditingController _checkController = TextEditingController();

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
      body: SingleChildScrollView(
        child: Stack(
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
                const SizedBox(
                    height: 600), // เพิ่มพื้นที่ว่างสำหรับ Card ที่จะเกยขึ้นมา
              ],
            ),
            Positioned(
              top: 120, // ปรับตำแหน่งตามต้องการ
              left: 8,
              right: 8,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'ตรวจรางวัลสลากกินแบ่งรัฐบาล',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 227, 35, 33)),
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2), // สีของเงา
                              spreadRadius: 2, // ระยะกระจายของเงา
                              blurRadius: 10, // ความเบลอของเงา
                              offset: const Offset(0, 5), // ตำแหน่งของเงา (X,Y)
                            ),
                          ],
                          borderRadius: BorderRadius.circular(
                              30), // เพิ่มความโค้งให้กับมุมของ Container (ถ้าต้องการ)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FilledButton(
                                  onPressed: () {},
                                  style: FilledButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color.fromARGB(
                                          255, 227, 35, 33),
                                      minimumSize: const Size(165, 50)),
                                  child: const Text(
                                    'ตรวจผลรางวัล',
                                    style: TextStyle(fontSize: 16),
                                  )),
                              FilledButton(
                                  onPressed: () {},
                                  style: FilledButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      backgroundColor: const Color.fromARGB(
                                          255, 224, 217, 217),
                                      minimumSize: const Size(165, 50)),
                                  child: const Text(
                                    'รายการรางวัล',
                                    style: TextStyle(fontSize: 16),
                                  ))
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextField(
                          controller: _checkController,
                          decoration: const InputDecoration(
                            labelText: 'กรุณากรอก',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color.fromARGB(255, 227, 35, 33),
                          minimumSize: const Size(
                              double.infinity, 50), // กำหนดให้ปุ่มเต็มความกว้าง
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10), // กำหนดมุมโค้งมน
                          ),
                        ),
                        child: const Text(
                          'ค้นหา',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [mainColor, darkerColor],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavButton(Icons.home, 0),
              _buildNavButton(Icons.search, 1),
              _buildNavButton(Icons.shopping_cart, 2),
              _buildNavButton(Icons.book, 3),
              _buildNavButton(Icons.check, 4),
            ],
          ),
        ),
      ),
    );
  }

  // สร้างฟังก์ชันนี้นอกจาก build method
  Widget _buildNavButton(IconData icon, int index) {
    return IconButton(
      icon: Icon(icon),
      color: _selectedIndex == index ? Colors.white : Colors.white70,
      onPressed: () {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
}
