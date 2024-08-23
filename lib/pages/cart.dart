import 'package:bidlotto/components/cards/lotto_card.dart';
import 'package:bidlotto/components/dialog/confirm.dart';
import 'package:bidlotto/components/dialog/result.dart';
import 'package:bidlotto/components/screens/main_screen_template.dart';
import 'package:bidlotto/services/api/lotto.dart';
import 'package:bidlotto/services/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Cart extends ConsumerStatefulWidget {
  const Cart({super.key});

  @override
  ConsumerState<Cart> createState() => _CartState();
}

class _CartState extends ConsumerState<Cart> {
  final Color mainColor = const Color(0xFFE32321);
  final Color darkerColor = const Color(0xFF7D1312);
  final Color yellowColor = const Color(0xFFFFCD00);

  @override
  void dispose() {
    super.dispose();
  }

  Future<dynamic> _getLottos() async {
    final apiService = ref.read(lottoServiceProvider);
    return await apiService.getAllLotto();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartServiceProvider);
    final cartService = ref.read(cartServiceProvider.notifier);
    return MainScreenTemplate(
      children: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: FutureBuilder<dynamic>(
              future: _getLottos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
                } else if (snapshot.hasData &&
                    snapshot.data['statusCode'] == 200) {
                  final res = snapshot.data!;
                  if (res['data'].length > 0) {
                    return Column(
                      children: [
                        BoxState(
                            onSeeItems: () {
                              debugPrint("${cartService.getCart()}");
                            },
                            mainColor: mainColor,
                            yellowColor: yellowColor,
                            itemCount: cartState.items.length),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Text("ทั้งหมด​ (${res['data'].length}) ",
                                  style: TextStyle(
                                      color: mainColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: res['data'].length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.5, // ปรับค่านี้ตามความเหมาะสม
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemBuilder: (context, index) {
                              final lotto = res['data'][index];
                              return LottoCard(
                                lottoNumber: lotto['number'] ?? '000000',
                                onAdded: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ConfirmDialog(
                                        title: 'จะเพิ่มลงตระกร้าหรือไม่?',
                                        onConfirm: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ResultDialog(
                                                isSuccess: true,
                                                message:
                                                    'เพิ่มลอตเตอรี่ลงในตะกร้าสำเร็จ',
                                                onClose: () {},
                                              );
                                            },
                                          );
                                          cartService.addToCart(lotto);
                                        },
                                        onCancel: () {},
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        )
                      ],
                    );
                  } else {
                    return Center(child: Text('ไม่มีข้อมูล'));
                  }
                } else if (snapshot.hasData &&
                    snapshot.data['statusCode'] == 401) {
                  return Center(
                    child: Text('Token หมดอายุกรุณา Login ใหม่ อีกครั้ง'),
                  );
                } else {
                  return Center(
                    child: Text('เกิดปัญหาบางอย่าง...'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BoxState extends StatelessWidget {
  const BoxState(
      {super.key,
      required this.mainColor,
      required this.yellowColor,
      required this.itemCount,
      required this.onSeeItems});

  final Color mainColor;
  final Color yellowColor;
  final int itemCount;
  final VoidCallback onSeeItems;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("ค้นหาเลขเด็ด",
                      style: TextStyle(
                          color: mainColor,
                          fontSize: 24,
                          fontWeight: FontWeight.normal)),
                  Container(
                    width: 47,
                    height: 34,
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    decoration: BoxDecoration(
                        color: yellowColor,
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.elliptical(20, 20),
                            right: Radius.elliptical(20, 20))),
                    child: GestureDetector(
                      onTap: () {
                        onSeeItems();
                      },
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                            ),
                          ),
                          Positioned(
                            top: -1,
                            right: 6,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                itemCount.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Text("งวดวันที่ 1 สิงหาคม 2567",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        )),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text("ล้างคำ",
                        style: TextStyle(
                          color: mainColor,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.red,
                        )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Flexible(
                    flex: 40,
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF1F1F1F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'สุ่มตัวเลข',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 60,
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: mainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'ค้นหา',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
