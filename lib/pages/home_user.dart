import 'package:bidlotto/services/api/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeUserPage extends ConsumerStatefulWidget {
  const HomeUserPage({super.key});

  @override
  ConsumerState<HomeUserPage> createState() => _HomeUserPageState();
}

class _HomeUserPageState extends ConsumerState<HomeUserPage> {
  final Color mainColor = const Color(0xFFE32321);
  final Color darkerColor = const Color(0xFF7D1312); // สีเข้มขึ้นเล็กน้อย

  @override
  Widget build(BuildContext context) {
    final apiService = ref.read(userServiceProvider);
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
                color: Colors.white,
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'งวดวันที่ \n16 สิงหาคม 2567',
                            style: TextStyle(fontSize: 16),
                          ),
                          ElevatedButton(
                            onPressed: () => {
                              apiService.getAllUser(),
                              context.push('/validate')
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black,
                            ),
                            child: const Text(
                              'ตรวจสอบรางวัล',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [mainColor, darkerColor],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            for (int i = 1; i <= 5; i++)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('รางวัลที่ $i',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                    const Text('546564',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                    Text('${7 - i} ล้านบาท',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                  ],
                                ),
                              ),
                          ],
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
    );
  }
}
