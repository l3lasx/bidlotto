import 'package:bidlotto/components/cards/lotto_card.dart';
import 'package:bidlotto/components/dialog/confirm.dart';
import 'package:bidlotto/components/dialog/result.dart';
import 'package:bidlotto/components/inputs/pin_input.dart';
import 'package:bidlotto/components/screens/main_screen_template.dart';
import 'package:bidlotto/services/api/lotto.dart';
import 'package:bidlotto/services/cart.dart';
import 'package:bidlotto/services/draw_prize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeValidate extends ConsumerStatefulWidget {
  final String lid;
  const HomeValidate({super.key, this.lid = ""});

  @override
  ConsumerState<HomeValidate> createState() => _HomeValidateState();
}

class _HomeValidateState extends ConsumerState<HomeValidate> {
  final Color mainColor = const Color(0xFFE32321);
  final Color darkerColor = const Color(0xFF7D1312);
  final TextEditingController _checkController = TextEditingController();
  bool isFirstButtonSelected = true;
  bool isSecondButtonSelected = false;
  bool showResult = false;
  bool checkValidate = false;
  bool getReward = false;
  final GlobalKey<StatefulPinInputTextFieldState> _pinInputKey = GlobalKey();

  Map<String, dynamic> prizeCheckData = {};

  @override
  void initState() {
    super.initState();
    if (widget.lid != "") {
      _checkController.text = widget.lid;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(drawPrizeProvider.notifier).checkPrizeStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartService = ref.read(cartServiceProvider.notifier);
    final drawPrizeState = ref.watch(drawPrizeProvider);
    return MainScreenTemplate(
      children: Card(
        color: Colors.white,
        elevation: 8,
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: !getReward
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'ตรวจรางวัลลอตเตอรี่',
                            style: TextStyle(fontSize: 20, color: mainColor),
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
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
                                child: FilledButton(
                                  onPressed: () {
                                    setState(() {
                                      isFirstButtonSelected = true;
                                      isSecondButtonSelected = false;
                                    });
                                  },
                                  style: FilledButton.styleFrom(
                                    foregroundColor: isFirstButtonSelected
                                        ? Colors.white
                                        : Colors.black,
                                    backgroundColor: isFirstButtonSelected
                                        ? mainColor
                                        : Color(0xFFE0D9D9),
                                    minimumSize: const Size(165, 50),
                                  ),
                                  child: const Text(
                                    'ตรวจผลรางวัล',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: FilledButton(
                                  onPressed: () {
                                    setState(() {
                                      showResult = false;
                                      isFirstButtonSelected = false;
                                      isSecondButtonSelected = true;
                                    });
                                  },
                                  style: FilledButton.styleFrom(
                                    foregroundColor: isSecondButtonSelected
                                        ? Colors.white
                                        : Colors.black,
                                    backgroundColor: isSecondButtonSelected
                                        ? mainColor
                                        : Color(0xFFE0D9D9),
                                    minimumSize: const Size(0, 50),
                                  ),
                                  child: const Text(
                                    'รายการรางวัล',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (isFirstButtonSelected)
                        Column(
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                // Your tap handling code
                              },
                              child: widget.lid != ""
                                  ? StatefulPinInputTextField(
                                      key: _pinInputKey,
                                      pinLength: 6,
                                      initialValue: widget.lid,
                                      onChanged: (String pin) {
                                        print('PIN changed: $pin');
                                        _checkController.text = pin;
                                      },
                                      automaticFocus: false,
                                      aspectRatio: 1,
                                      textStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    )
                                  : StatefulPinInputTextField(
                                      key: _pinInputKey,
                                      pinLength: 6,
                                      onChanged: (String pin) {
                                        setState(() {
                                          _checkController.text = pin;
                                        });
                                      },
                                      automaticFocus: false,
                                      aspectRatio: 1,
                                      textStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 10),
                            if (!showResult)
                              FilledButton(
                                onPressed: () async {
                                  if (!drawPrizeState.isPrizeDrawn) {
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ResultDialog(
                                          isSuccess: false,
                                          message: 'ขณะนี้ยังไม่มีการออกรางวัล',
                                          onClose: () {},
                                        );
                                      },
                                    );
                                  } else {
                                    validate();
                                  }
                                },
                                style: FilledButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: mainColor,
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: const Text(
                                  'ค้นหา',
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            else
                              !checkValidate
                                  ? Column(
                                      children: [
                                        Image.asset('assets/images/sad.png'),
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              top: 20, bottom: 20),
                                          child: Center(
                                            child: Text(
                                              'เสียใจด้วยคุณพลาดเงินล้าน !',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 25),
                                            ),
                                          ),
                                        ),
                                        FilledButton(
                                          onPressed: () async {
                                            if (!drawPrizeState.isPrizeDrawn) {
                                              await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return ResultDialog(
                                                    isSuccess: false,
                                                    message:
                                                        'ขณะนี้ยังไม่มีการออกรางวัล',
                                                    onClose: () {},
                                                  );
                                                },
                                              );
                                            } else {
                                              validate();
                                            }
                                          },
                                          style: FilledButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: mainColor,
                                            minimumSize:
                                                const Size(double.infinity, 50),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                          child: const Text(
                                            'ตรวจสอบอีกครั้ง',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        )
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        Image.asset('assets/images/happy.png'),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 20, bottom: 10),
                                          child: Column(
                                            children: [
                                              Center(
                                                child: Text(
                                                  'ยินดีด้วยคุณถูกลอตเตอรี่ !',
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 25),
                                                ),
                                              ),
                                              Center(
                                                  child: Text(
                                                'รางวัลที่ ${prizeCheckData['data']['seq']}',
                                                style: TextStyle(fontSize: 20),
                                              )),
                                              Center(
                                                  child: Text(
                                                'เงินรางวัล ${prizeCheckData['data']['reward_point']}฿',
                                                style: TextStyle(fontSize: 20),
                                              )),
                                            ],
                                          ),
                                        ),
                                        FilledButton(
                                          onPressed: () async {
                                            if (!drawPrizeState.isPrizeDrawn) {
                                              await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return ResultDialog(
                                                    isSuccess: false,
                                                    message:
                                                        'ขณะนี้ยังไม่มีการออกรางวัล',
                                                    onClose: () {},
                                                  );
                                                },
                                              );
                                            } else {
                                              validate();
                                            }
                                          },
                                          style: FilledButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: mainColor,
                                            minimumSize:
                                                const Size(double.infinity, 50),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                          child: const Text(
                                            'ตรวจสอบอีกครั้ง',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        FilledButton(
                                          onPressed: () {
                                            redeemLotto();
                                          },
                                          style: FilledButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.blue,
                                            minimumSize:
                                                const Size(double.infinity, 50),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                          child: const Text(
                                            'ขึ้นรางวัล',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        )
                                      ],
                                    ),
                            if (!drawPrizeState.isPrizeDrawn)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("ขณะนี้ยังไม่มีการออกรางวัล"),
                              )
                          ],
                        )
                      else
                        FutureBuilder<dynamic>(
                          future: cartService.orderMe(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            } else if (snapshot.hasError) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: Text(
                                        'เกิดข้อผิดพลาด: ${snapshot.error}')),
                              );
                            } else if (snapshot.hasData &&
                                snapshot.data['statusCode'] == 200) {
                              final res = snapshot.data!;
                              final orders = res['data']['orders'];

                              // Combine all items into a single array
                              final allItems = orders.expand((order) {
                                if (order['orderStatus'] == 2) {
                                  final items = order['items'] as List<dynamic>;
                                  return items.map(
                                      (item) => item as Map<String, dynamic>);
                                }
                                return <Map<String,
                                    dynamic>>[]; // Return an empty list instead of null
                              }).toList();
                              return allItems.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
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
                                            onTap: () {
                                              if (lotto['lottoStatus'] == 2) {
                                                setState(() {
                                                  isFirstButtonSelected = true;
                                                  isSecondButtonSelected =
                                                      false;
                                                  showResult = false;
                                                  _checkController.text =
                                                      lotto['number'];
                                                });
                                                GoRouter.of(context).go(
                                                    '/validate/${lotto['number']}');
                                              }
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
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ยินดีด้วยคุณถูกรางวัล',
                          style: TextStyle(fontSize: 20),
                        ),
                        Row(
                          children: [
                            Text(
                              'เลขที่ ',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              _checkController.text,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Column(
                            children: [
                              Image.asset('assets/images/reward.png'),
                              const Text(
                                'รับเงินสำเร็จ!',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.green),
                              ),
                              Text(
                                'เงินรางวัล ${prizeCheckData['data']['reward_point']}฿',
                                style: TextStyle(fontSize: 25),
                              ),
                              const SizedBox(height: 10),
                              FilledButton(
                                onPressed: () {
                                  setState(() {
                                    getReward = false;
                                    showResult = false;
                                    isFirstButtonSelected = false;
                                    isSecondButtonSelected = true;
                                  });
                                },
                                style: FilledButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: mainColor,
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: const Text(
                                  'ตกลง',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
      ),
    );
  }

  void validate() async {
    if (_checkController.text.length == 6) {
      final apiService = ref.read(lottoServiceProvider);
      Map<String, dynamic> res =
          await apiService.checkLotto(_checkController.text);
      print(res);
      setState(() {
        prizeCheckData = res;
      });
      if (res["statusCode"] == 200) {
        if (res["data"]["win"]) {
          setState(() {
            showResult = true;
            checkValidate = true;
          });
        } else {
          setState(() {
            showResult = true;
            checkValidate = false;
          });
        }
      }
    }
  }

  void redeemLotto() async {
    var isConfirm = false;
    bool? shouldAdd = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          title: 'จะขึ้นรางวัลหรือไม่?',
          onConfirm: () => {isConfirm = true},
          onCancel: () => {},
        );
      },
    );
    if (shouldAdd != true && !isConfirm) return;
    final apiService = ref.read(lottoServiceProvider);
    Map<String, dynamic> res =
        await apiService.redeemLotto(_checkController.text);
    print(res);
    if (res["statusCode"] == 200) {
      if (!context.mounted) return;
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ResultDialog(
            isSuccess: true,
            message: "ยินดีด้วยคุณถูกรางวัล",
            onClose: () {
              setState(() {
                getReward = true;
              });
            },
          );
        },
      );
    } else {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ResultDialog(
            isSuccess: false,
            message: res["data"]["message"],
            onClose: () {
              setState(() {
                getReward = false;
              });
            },
          );
        },
      );
    }
  }
}
