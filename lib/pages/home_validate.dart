import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeValidate extends StatefulWidget {
  final String lid;
  const HomeValidate({super.key, this.lid = ""});

  @override
  State<HomeValidate> createState() => _HomeValidateState();
}

class _HomeValidateState extends State<HomeValidate> {
  final Color mainColor = const Color(0xFFE32321);
  final Color darkerColor = const Color(0xFF7D1312);
  final TextEditingController _checkController = TextEditingController();
  bool isFirstButtonSelected = true;
  bool isSecondButtonSelected = false;
  bool showResult = false;
  bool checkValidate = false;
  bool getReward = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.motorcycle, color: Colors.white),
                SizedBox(width: 8),
                Text('Bidlotto', style: TextStyle(color: Colors.white)),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () {
                context.push('/profile');
              },
            ),
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
                const SizedBox(height: 600),
              ],
            ),
            Positioned(
              top: 120,
              left: 8,
              right: 8,
              child: Card(
                color: Colors.white,
                elevation: 8,
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: !getReward
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${widget.lid}"),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    'ตรวจรางวัลสลากกินแบ่งรัฐบาล',
                                    style: TextStyle(
                                        fontSize: 20, color: mainColor),
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
                                            foregroundColor:
                                                isFirstButtonSelected
                                                    ? Colors.white
                                                    : Colors.black,
                                            backgroundColor:
                                                isFirstButtonSelected
                                                    ? mainColor
                                                    : const Color.fromARGB(
                                                        255, 224, 217, 217),
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
                                              isFirstButtonSelected = false;
                                              isSecondButtonSelected = true;
                                            });
                                          },
                                          style: FilledButton.styleFrom(
                                            foregroundColor:
                                                isSecondButtonSelected
                                                    ? Colors.white
                                                    : Colors.black,
                                            backgroundColor:
                                                isSecondButtonSelected
                                                    ? mainColor
                                                    : const Color.fromARGB(
                                                        255, 224, 217, 217),
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
                                    LotteryNumberInput(
                                      onChanged: (value) {
                                        setState(() {
                                          _checkController.text = value;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    if (!showResult)
                                      FilledButton(
                                        onPressed: validate,
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
                                          'ค้นหา',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      )
                                    else
                                      !checkValidate
                                          ? Column(
                                              children: [
                                                Image.asset(
                                                    'assets/images/sad.png'),
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 20, bottom: 20),
                                                  child: Center(
                                                    child: Text(
                                                      'เสียใจด้วยคุณพลาดเงินล้าน !',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 25),
                                                    ),
                                                  ),
                                                ),
                                                FilledButton(
                                                  onPressed: validate,
                                                  style: FilledButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.white,
                                                    backgroundColor: mainColor,
                                                    minimumSize: const Size(
                                                        double.infinity, 50),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'ตรวจสอบอีกครั้ง',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                )
                                              ],
                                            )
                                          : Column(
                                              children: [
                                                Image.asset(
                                                    'assets/images/happy.png'),
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 20, bottom: 10),
                                                  child: Center(
                                                    child: Text(
                                                      'ยินดีด้วยคุณถูกลอตเตอรี่ !',
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 25),
                                                    ),
                                                  ),
                                                ),
                                                FilledButton(
                                                  onPressed: validate,
                                                  style: FilledButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.white,
                                                    backgroundColor: mainColor,
                                                    minimumSize: const Size(
                                                        double.infinity, 50),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'ตรวจสอบอีกครั้ง',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                FilledButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      getReward = true;
                                                    });
                                                  },
                                                  style: FilledButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.white,
                                                    backgroundColor:
                                                        Colors.blue,
                                                    minimumSize: const Size(
                                                        double.infinity, 50),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'ขึ้นรางวัล',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                )
                                              ],
                                            )
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [darkerColor, mainColor],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  '999999',
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      color: Colors.white),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      '1 สิงหาคม 2567',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              165,
                                                              165,
                                                              165)),
                                                    ),
                                                    FilledButton(
                                                        style: FilledButton
                                                            .styleFrom(
                                                                foregroundColor:
                                                                    Colors
                                                                        .white,
                                                                backgroundColor:
                                                                    Colors
                                                                        .green),
                                                        onPressed: () {},
                                                        child: const Text(
                                                            'ถูกรางวัล'))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [darkerColor, mainColor],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  '123456',
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      color: Colors.white),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      '1 สิงหาคม 2567',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              165,
                                                              165,
                                                              165)),
                                                    ),
                                                    FilledButton(
                                                        style: FilledButton
                                                            .styleFrom(
                                                                foregroundColor:
                                                                    Colors
                                                                        .white,
                                                                backgroundColor:
                                                                    Colors
                                                                        .grey),
                                                        onPressed: () {},
                                                        child: const Text(
                                                            'ไม่ถูกรางวัล'))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [darkerColor, mainColor],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  '654321',
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      color: Colors.white),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      '1 สิงหาคม 2567',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              165,
                                                              165,
                                                              165)),
                                                    ),
                                                    FilledButton(
                                                        style: FilledButton
                                                            .styleFrom(
                                                                foregroundColor:
                                                                    Colors
                                                                        .white,
                                                                backgroundColor:
                                                                    Colors
                                                                        .grey),
                                                        onPressed: () {},
                                                        child: const Text(
                                                            'ไม่ถูกรางวัล'))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ยินดีด้วยคุณถูกรางวัล',
                                style: TextStyle(fontSize: 20),
                              ),
                              const Row(
                                children: [
                                  Text(
                                    'เลขที่ ',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    '999999',
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
                                    const Text(
                                      'เงินรางวัล 1,000,000฿',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    const SizedBox(height: 10),
                                    FilledButton(
                                      onPressed: () {
                                        setState(() {
                                          getReward = false;
                                          isFirstButtonSelected = false;
                                          isSecondButtonSelected = true;
                                        });
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
                                        'ตกลง',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void validate() {
    setState(() {
      showResult = true;
      if (_checkController.text.length == 6) {
        if (int.parse(_checkController.text) == 999999) {
          checkValidate = true;
        } else {
          checkValidate = false;
        }
      } else {
        checkValidate = false;
      }
    });
  }
}

class LotteryNumberInput extends StatefulWidget {
  final Function(String) onChanged;

  const LotteryNumberInput({Key? key, required this.onChanged})
      : super(key: key);

  @override
  _LotteryNumberInputState createState() => _LotteryNumberInputState();
}

class _LotteryNumberInputState extends State<LotteryNumberInput> {
  List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());
  List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) {
      controllers[i].addListener(() {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 55,
          child: TextFormField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: "",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 5) {
                focusNodes[index + 1].requestFocus();
              }
              widget.onChanged(controllers.map((c) => c.text).join());
            },
            onFieldSubmitted: (_) {
              if (index < 5) {
                focusNodes[index + 1].requestFocus();
              }
            },
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}
