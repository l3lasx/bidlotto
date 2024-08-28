import 'package:bidlotto/components/cards/lotto_item.dart';
import 'package:bidlotto/components/dialog/confirm.dart';
import 'package:bidlotto/components/dialog/result.dart';
import 'package:bidlotto/components/screens/main_screen_template.dart';
import 'package:bidlotto/services/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CartResult extends ConsumerStatefulWidget {
  const CartResult({super.key});

  @override
  ConsumerState<CartResult> createState() => _CartResultState();
}

class _CartResultState extends ConsumerState<CartResult> {
  Future<dynamic> getCartItems() async {
    final cartService = ref.read(cartServiceProvider.notifier);
    await Future<void>.delayed(const Duration(seconds: 1));
    return cartService.getCart();
  }

  Future<void> showRemoveLotto(BuildContext context, dynamic lotto) async {
    final cartService = ref.read(cartServiceProvider.notifier);
    var isConfirm = false;
    bool? popup = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          title: 'จะลบออกจากตระกร้าหรือไม่?',
          onConfirm: () => {isConfirm = true},
          onCancel: () => {},
        );
      },
    );
    if (popup != true && !isConfirm) return;
    try {
      final res = await cartService.removeFromCart(lotto);
      if (!context.mounted) return;
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ResultDialog(
            isSuccess: res['statusCode'] == 200,
            message: res['data']['message'],
            onClose: () async {
              await cartService.loadCart();
            },
          );
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ResultDialog(
            isSuccess: false,
            message: 'เกิดข้อผิดพลาด: ${e.toString()}',
            onClose: () {},
          );
        },
      );
    }
  }

  Future<void> showBuyLotto(BuildContext context) async {
    final cartService = ref.read(cartServiceProvider.notifier);
    var isConfirm = false;
    bool? popup = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          title: 'ต้องการชำระหรือไม่',
          onConfirm: () => {isConfirm = true},
          onCancel: () => {},
        );
      },
    );
    if (popup != true && !isConfirm) return;
    try {
      final res = await cartService.buyItemsInCart();
      if (!context.mounted) return;
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ResultDialog(
            isSuccess: res['statusCode'] == 200,
            message: res['data']['message'],
            onClose: () async {
              await cartService.loadCart();
            },
          );
        },
      );
      GoRouter.of(context).go('/wallet');
    } catch (e) {
      if (!context.mounted) return;
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ResultDialog(
            isSuccess: false,
            message: 'เกิดข้อผิดพลาด: ${e.toString()}',
            onClose: () {},
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color mainColor = const Color(0xFFE32321);
    final Color darkerColor = const Color(0xFF7D1312);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final cartService = ref.read(cartServiceProvider.notifier);
    final cartState = ref.watch(cartServiceProvider);
    return MainScreenTemplate(
        children: Column(children: [
      ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: screenWidth * 0.95, minWidth: 300),
        child: Card(
          color: Colors.white,
          elevation: 8,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 100,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [mainColor, darkerColor],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: darkerColor.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'คำสั่งซื้อ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isSmallScreen ? 16 : 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                FutureBuilder<dynamic>(
                    future: getCartItems(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text('เกิดข้อผิดพลาด: ${snapshot.error}')),
                        );
                      } else if (snapshot.hasData) {
                        final cartItems = snapshot.data as List<dynamic>;
                        if (cartItems.isNotEmpty) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "รายการลอตเตอรี่",
                                      style: TextStyle(
                                          fontSize: isSmallScreen ? 16 : 18),
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                children: cartItems.map((lotto) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: LottoItem(
                                      number: lotto['number'],
                                      quantity: 1,
                                      price: lotto['price'].toDouble(),
                                      onDelete: () {
                                        showRemoveLotto(context, lotto);
                                      },
                                    ),
                                  );
                                }).toList(),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "สรุปรายการทั้งหมด",
                                      style: TextStyle(
                                          fontSize: isSmallScreen ? 16 : 18),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "ค่าลอตเตอรี่",
                                      style: TextStyle(
                                          fontSize: isSmallScreen ? 14 : 16,
                                          color: mainColor),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "จำนวนลอตเตอรี่ X ${cartItems.length} ใบ",
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 14 : 16,
                                      ),
                                    ),
                                    Text(
                                      "${cartState.totalAmount.toString()} บาท",
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 14 : 16,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "รวมเป็นเงินทั้งสิ้น",
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 14 : 16,
                                      ),
                                    ),
                                    Text(
                                      "${cartService.getTotalAmount().toString()} บาท",
                                      style: TextStyle(
                                          fontSize: isSmallScreen ? 14 : 16,
                                          color: mainColor),
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 100,
                                    child: GestureDetector(
                                      onTap: () {
                                        showBuyLotto(context);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 16),
                                        decoration: BoxDecoration(
                                          color: mainColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  darkerColor.withOpacity(0.3),
                                              spreadRadius: 1,
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            'ดำเนินการต่อ',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: isSmallScreen ? 16 : 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('ไม่มีรายการในตะกร้า'),
                          );
                        }
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text('เกิดปัญหาบางอย่าง...'),
                          ),
                        );
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
      SizedBox(height: 100)
    ]));
  }
}
