import 'dart:developer';

import 'package:bidlotto/model/userModel.dart';
import 'package:bidlotto/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/api/user.dart';

class WalletPage extends ConsumerStatefulWidget {
  const WalletPage({super.key});

  @override
  ConsumerState<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
  final Color mainColor = const Color(0xFFE32321);
  final Color darkerColor = const Color(0xFF7D1312);

  // เพิ่มตัวแปรเพื่อติดตามสถานะของปุ่มที่ถูกเลือก
  bool showAllOrders = true;
  UserModel? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final authstate = ref.read(authServiceProvider);
    final user = authstate.user;
    if (user != null && user.id != null) {
      final apiService = ref.read(userServiceProvider);
      try {
        final data = await apiService.getUserById(user.id!);
        if (data != null && data['data'] != null) {
          setState(() {
            userData = UserModel.fromJson(data['data']);
            log(userData.toString());
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
        // อาจจะแสดง error message ให้ user ทราบด้วย
      }
    }
  }

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
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('กระเป๋าของฉัน',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('เครดิตที่เหลือ',
                                    style: TextStyle(fontSize: 16)),
                                Text(
                                  userData != null
                                      ? '${userData!.wallet ?? 0} บาท'
                                      : 'กำลังโหลด...',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
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
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 290,
              left: 8,
              right: 8,
              child: Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  // อัปเดต onPressed เพื่อเปลี่ยนสถานะ showAllOrders
                                  onPressed: () {
                                    setState(() {
                                      showAllOrders = true;
                                    });
                                  },
                                  // ปรับสีปุ่มตามสถานะ showAllOrders
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: showAllOrders
                                        ? mainColor
                                        : Colors.grey[300],
                                    foregroundColor: showAllOrders
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  child: const Text('ออเดอร์ทั้งหมด',
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  // อัปเดต onPressed เพื่อเปลี่ยนสถานะ showAllOrders
                                  onPressed: () {
                                    setState(() {
                                      showAllOrders = false;
                                    });
                                  },
                                  // ปรับสีปุ่มตามสถานะ showAllOrders
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: !showAllOrders
                                        ? mainColor
                                        : Colors.grey[300],
                                    foregroundColor: !showAllOrders
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  child: const Text('ลอตเตอรี่ทั้งหมด',
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // แสดงข้อความต่างกันตามสถานะของ showAllOrders
                      if (showAllOrders)
                        const Center(
                          child: Text(
                            'ไม่พบคำสั่งซื้อในขณะนี้',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      else
                        const Center(
                          child: Text(
                            'ไม่พบลอตเตอรี่ในขณะนี้',
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
    );
  }
}
