import 'dart:math';

import 'package:animated_pin_input_text_field/animated_pin_input_text_field.dart';
import 'package:bidlotto/components/cards/lotto_card.dart';
import 'package:bidlotto/components/dialog/confirm.dart';
import 'package:bidlotto/components/dialog/result.dart';
import 'package:bidlotto/components/screens/main_screen_template.dart';
import 'package:bidlotto/services/api/lotto.dart';
import 'package:bidlotto/services/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Cart extends ConsumerStatefulWidget {
  const Cart({super.key});

  @override
  ConsumerState<Cart> createState() => _CartState();
}

class _CartState extends ConsumerState<Cart> {
  final Color mainColor = const Color(0xFFE32321);
  final Color darkerColor = const Color(0xFF7D1312);
  final Color yellowColor = const Color(0xFFFFCD00);
  final TextEditingController _lottoController = TextEditingController();
  late Future<void> loadData;
  @override
  void dispose() {
    super.dispose();
    _lottoController.dispose();
  }

  @override
  initState() {
    super.initState();
    loadData = _getLottos();
  }

  Future<dynamic> _getLottos() async {
    final apiService = ref.read(lottoServiceProvider);
    await Future<void>.delayed(const Duration(seconds: 1));
    return await apiService.getAllLotto();
  }

  Future<void> showAddToCartDialog(BuildContext context, dynamic lotto) async {
    final cartService = ref.read(cartServiceProvider.notifier);
    var isConfirm = false;
    bool? shouldAdd = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          title: 'จะเพิ่มลงตระกร้าหรือไม่?',
          onConfirm: () => {isConfirm = true},
          onCancel: () => {},
        );
      },
    );
    if (shouldAdd != true && !isConfirm) return;
    try {
      final res = await cartService.addToCart(lotto);
      if (!context.mounted) return;
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ResultDialog(
            isSuccess: res['statusCode'] == 200,
            message: res['data']['message'],
            onClose: () {
              cartService.loadCart();
              loadData = _getLottos();
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

  Future<dynamic> callSearch(String term) async {
    final apiService = ref.read(lottoServiceProvider);
    await Future<void>.delayed(const Duration(seconds: 1));
    return await apiService.searchLotto(term);
  }

  Future<dynamic> searchLotto(String term) async {
    setState(() {
      loadData = callSearch(term);
    });
  }

  void randomLotto() {
    setState(() {
      loadData = _getLottos().then((dynamic data) {
        if (data != null && data['statusCode'] == 200) {
          final lottos =
              data['data'].where((item) => item['status'] == 0).toList();
          if (lottos.isNotEmpty) {
            final random = Random();
            final randomLotto = lottos[random.nextInt(lottos.length)];
            return {
              'statusCode': 200,
              'data': [randomLotto]
            };
          }
        }
        return data; // Return original data if conditions are not met
      });
    });
  }

  final GlobalKey<PinInputTextFieldState> _pinInputKey =
      GlobalKey<PinInputTextFieldState>();

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartServiceProvider);
    // final cartService = ref.read(cartServiceProvider.notifier);
    return MainScreenTemplate(
      children: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              children: [
                BoxState(
                    controller: _lottoController,
                    onSeeItems: () {
                      GoRouter.of(context).go('/cart_result');
                    },
                    onRandom: () {
                      randomLotto();
                    },
                    onSearch: () async {
                      if (_lottoController.text.length == 6) {
                        await searchLotto(_lottoController.text);
                      } else {
                        setState(() {
                          loadData = _getLottos();
                        });
                      }
                    },
                    onClearInput: () {
                      // _lottoController.clear();
                    },
                    pinInputKey: _pinInputKey,
                    mainColor: mainColor,
                    yellowColor: yellowColor,
                    itemCount: cartState.items.length),
                SizedBox(height: 10),
                FutureBuilder<dynamic>(
                  future: loadData,
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
                    } else if (snapshot.hasData &&
                        snapshot.data['statusCode'] == 200) {
                      final res = snapshot.data!;
                      final lottos = res['data']
                          .where((item) => item['status'] == 0)
                          .toList();
                      return lottos.length > 0
                          ? Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    children: [
                                      Text("ทั้งหมด​ (${lottos.length}) ",
                                          style: TextStyle(
                                              color: mainColor,
                                              fontSize: 24,
                                              fontWeight: FontWeight.normal)),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: lottos.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1.5,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                    ),
                                    itemBuilder: (context, index) {
                                      final lotto = lottos[index];
                                      return LottoCard(
                                        lottoNumber:
                                            lotto['number'] ?? '000000',
                                        lottoStatus: lotto['status'],
                                        onAdded: () {
                                          showAddToCartDialog(context, lotto);
                                        },
                                      );
                                    },
                                  ),
                                )
                              ],
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text('ไม่มีข้อมูล')),
                            );
                    } else if (snapshot.hasData &&
                        snapshot.data['statusCode'] == 401) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Token หมดอายุกรุณา Login ใหม่ อีกครั้ง'),
                        ),
                      );
                    } else {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('เกิดปัญหาบางอย่าง...'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BoxState extends StatelessWidget {
  BoxState(
      {Key? key,
      required this.mainColor,
      required this.yellowColor,
      required this.itemCount,
      required this.onSeeItems,
      required this.onClearInput,
      required this.onRandom,
      required this.onSearch,
      required this.pinInputKey,
      required this.controller})
      : super(key: key);

  final Color mainColor;
  final Color yellowColor;
  final int itemCount;
  final VoidCallback onSeeItems;
  final VoidCallback onSearch;
  final VoidCallback onRandom;
  final VoidCallback onClearInput;
  final TextEditingController controller;
  final GlobalKey<PinInputTextFieldState> pinInputKey;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: screenWidth * 0.95,
        minWidth: 300,
      ),
      child: Card(
        color: Colors.white,
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "ค้นหาเลขเด็ด",
                      style: TextStyle(
                        color: mainColor,
                        fontSize: isSmallScreen ? 20 : 24,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Container(
                    width: 47,
                    height: 34,
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    decoration: BoxDecoration(
                      color: yellowColor,
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.elliptical(20, 20),
                        right: Radius.elliptical(20, 20),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: onSeeItems,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child:
                                Icon(Icons.shopping_cart, color: Colors.white),
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
              SizedBox(height: 40),
              PinInputTextField(
                automaticFocus: false,
                aspectRatio: 1,
                pinLength: 6,
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                onChanged: (String value) {
                  controller.text = value;
                },
                key: pinInputKey,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 40,
                    child: Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: FilledButton(
                        onPressed: () {
                          onRandom();
                        },
                        style: FilledButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF1F1F1F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'สุ่มตัวเลข',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 60,
                    child: FilledButton(
                      onPressed: () {
                        onSearch();
                      },
                      style: FilledButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'ค้นหา',
                        style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
