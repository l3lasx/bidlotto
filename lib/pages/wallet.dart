import 'package:flutter/material.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  int _selectedIndex = 0;
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
                        'ชุดใหญ่ โอนไว ไม่โอนคืน',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 600),
              ],
            ),
            Positioned(
              top: 120,
              left: 8,
              right: 8,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('กระเป๋าของฉัน', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('เครดิตที่เหลือ', style: TextStyle(fontSize: 16)),
                                Text('1,000 บาท', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('เติมเงิน'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainColor,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('ลอตเตอรี่ทั้งหมด'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                                foregroundColor: Colors.black,
                              ),
                              child: const Text('ลอตเตอรี่ทั้งหมด'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Center(
                        child: Text(
                          'ไม่พบคำสั่งซื้อในขณะนี้',
                          style: TextStyle(color: Colors.grey),
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