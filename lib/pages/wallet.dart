import 'dart:developer';

import 'package:bidlotto/components/cards/lotto_card.dart';
import 'package:bidlotto/components/cards/order_cart.dart';
import 'package:bidlotto/components/screens/main_screen_template.dart';
import 'package:bidlotto/model/userModel.dart';
import 'package:bidlotto/services/auth.dart';
import 'package:bidlotto/services/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    final cartService = ref.read(cartServiceProvider.notifier);
    return MainScreenTemplate(
        children: Column(
      children: [
        Card(
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
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                                fontSize: 18, fontWeight: FontWeight.bold),
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
        Card(
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
                              backgroundColor:
                                  showAllOrders ? mainColor : Colors.grey[300],
                              foregroundColor:
                                  showAllOrders ? Colors.white : Colors.black,
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
                              backgroundColor:
                                  !showAllOrders ? mainColor : Colors.grey[300],
                              foregroundColor:
                                  !showAllOrders ? Colors.white : Colors.black,
                            ),
                            child: const Text('ทั้งหมด',
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
                  FutureBuilder<dynamic>(
                    future: cartService.orderMe(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text('เกิดข้อผิดพลาด: ${snapshot.error}')),
                        );
                      } else if (snapshot.hasData &&
                          snapshot.data['statusCode'] == 200) {
                        final res = snapshot.data!;
                        final allOrders = res['data']['orders'];
                        final orders = allOrders
                            .where((order) => order['orderStatus'] == 1)
                            .toList();

                        return orders.isNotEmpty
                            ? Column(
                                children: orders.map<Widget>((order) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    child: OrderList(
                                      title:
                                          "หมายเลขคำสั่งซื้อ ${order['orderId']}",
                                      total: order['totalAmount'],
                                      items: order['items'],
                                    ),
                                  );
                                }).toList(),
                              )
                            : const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(child: Text('ไม่มีคำสั่งซื้อ')),
                              );
                      }
                      return const Center(
                        child: Text(
                          'ไม่พบคำสั่งซื้อในขณะนี้',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    },
                  )
                else
                  FutureBuilder<dynamic>(
                    future: cartService.orderMe(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text('เกิดข้อผิดพลาด: ${snapshot.error}')),
                        );
                      } else if (snapshot.hasData &&
                          snapshot.data['statusCode'] == 200) {
                        final res = snapshot.data!;
                        final orders = res['data']['orders'];

                        // Combine all items into a single array
                        final allItems = orders.expand((order) {
                          if (order['orderStatus'] == 2) {
                            final items = order['items'] as List<dynamic>;
                            return items
                                .map((item) => item as Map<String, dynamic>);
                          }
                          return <Map<String,
                              dynamic>>[]; // Return an empty list instead of null
                        }).toList();
                        return allItems.isNotEmpty
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: allItems.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1,
                                    childAspectRatio: 3,
                                    crossAxisSpacing: 2,
                                    mainAxisSpacing: 4,
                                  ),
                                  itemBuilder: (context, index) {
                                    final lotto = allItems[index];
                                    return GestureDetector(
                                      onTap: (){
                                        GoRouter.of(context).go('/validate/${lotto['number']}');
                                      },
                                      child: LottoCard(
                                        lottoNumber:
                                            lotto['number'] ?? '000000',
                                        dateLotto: lotto['expiredDate'],
                                        isShowIconCart: false,
                                        lottoStatus: lotto['lottoStatus'],
                                        onAdded: () {},
                                      ),
                                    );
                                  },
                                ),
                              )
                            : const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(child: Text('ไม่มีข้อมูล')),
                              );
                      }
                      return const Center(
                        child: Text(
                          'ไม่พบคำสั่งซื้อในขณะนี้',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    },
                  )
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
