import 'dart:math';
import 'dart:ui';
import 'package:betting_simulator/generated/assets.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

import 'package:gradient_icon/gradient_icon.dart';

void main() {
  runApp(const BettingSimulatorApp());
}

class BettingSimulatorApp extends StatelessWidget {
  const BettingSimulatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Betting Simulator',
      theme: ThemeData(
          colorSchemeSeed: const Color(0xffFED50B)
      ),
      home: const SpinningWheelPage(),
    );
  }
}


class SpinningWheelPage extends StatefulWidget {
  const SpinningWheelPage({super.key});

  @override
  SpinningWheelPageState createState() => SpinningWheelPageState();
}

class SpinningWheelPageState extends State<SpinningWheelPage> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  final List<Coin> coinsList = [];
  final int totalCoins = 50;

  bool first = true;

  @override
  void initState() {
    _currentItemList = spinStages[0]; // Start with stage 1
    super.initState();
  }

  void _generateCoins() {
    final random = Random();
    for (int i = 0; i < totalCoins; i++) {
      // Random position for each coin
      double xPosition = random.nextDouble() * MediaQuery.of(context).size.width;
      double speed = random.nextDouble() * 0.5 + 0.5; // Random speed between 0.5 and 1.0
      coinsList.add(Coin(x: xPosition, speed: speed));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    selected.close();
    super.dispose();
  }

  StreamController<int> selected = StreamController<int>();

  MySpinController mySpinController = MySpinController();

  int coins = 5;

  List<SpinItem> _currentItemList = [];
  int spinCount = 0;
  int spinStage = 0;

  // Spin items stages
  List<List<SpinItem>> spinStages = [
    // Stage 1: Low risk, low rewards
    [
      SpinItem(label: '+2', labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xffffeb3b).withOpacity(0.7), win: true),
      SpinItem(label: '-1', labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xfff44336).withOpacity(0.7), win: false),
      SpinItem(label: '+3', labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xffffeb3b).withOpacity(0.7), win: true),
      SpinItem(label: '+1', labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xffffeb3b).withOpacity(0.7), win: true),
      SpinItem(label: '-1', labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xfff44336).withOpacity(0.7), win: false),
      SpinItem(label: '+4', labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xffffeb3b).withOpacity(0.7), win: true),
      SpinItem(label: '+3', labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xffffeb3b).withOpacity(0.7), win: true),
      SpinItem(label: '-1', labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xfff44336).withOpacity(0.7), win: false),
    ],
    // Stage 2: Medium risk, medium rewards
    [
      SpinItem(label: '+5', labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xffffeb3b).withOpacity(0.7), win: true),
      SpinItem(label: '-3', labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xfff44336).withOpacity(0.7), win: false),
      SpinItem(label: '-2', labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xfff44336).withOpacity(0.7), win: false),
      SpinItem(label: '-1', labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xfff44336).withOpacity(0.7), win: false),
      SpinItem(label: '+7', labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xffffeb3b).withOpacity(0.7), win: true),
      SpinItem(label: '+3', labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xffffeb3b).withOpacity(0.7), win: true),
      SpinItem(label: '-1', labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xfff44336).withOpacity(0.7), win: false),
      SpinItem(label: '+1', labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xffffeb3b).withOpacity(0.7), win: true),
    ],
    [
      SpinItem(label: '+2', labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xffffeb3b).withOpacity(0.7), win: true),
      SpinItem(label: '-1', labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xfff44336).withOpacity(0.7), win: false),
      SpinItem(label: '+3', labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xffffeb3b).withOpacity(0.7), win: true),
      SpinItem(label: '+1', labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xffffeb3b).withOpacity(0.7), win: true),
      SpinItem(label: '-1', labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xfff44336).withOpacity(0.7), win: false),
      SpinItem(label: '-3', labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xfff44336).withOpacity(0.7), win: false),
      SpinItem(label: '+1', labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xffffeb3b).withOpacity(0.7), win: true),
      SpinItem(label: '-1', labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xfff44336).withOpacity(0.7), win: false),
    ],
    [
      SpinItem(label: '+7', labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xffffeb3b).withOpacity(0.7), win: true),
      SpinItem(label: '-4', labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xfff44336).withOpacity(0.7), win: false),
      SpinItem(label: '-1', labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xfff44336).withOpacity(0.7), win: false),
      SpinItem(label: '+1', labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xffffeb3b).withOpacity(0.7), win: true),
      SpinItem(label: '+8', labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xffffeb3b).withOpacity(0.7), win: true),
      SpinItem(label: '-5', labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xfff44336).withOpacity(0.7), win: false),
      SpinItem(label: '-1', labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xfff44336).withOpacity(0.7), win: false),
      SpinItem(label: '+1', labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xffffeb3b).withOpacity(0.7), win: true),
    ],
    // Stage 3: High risk, high rewards
    [
      SpinItem(label: '+10', labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xffffeb3b).withOpacity(0.7), win: true),
      SpinItem(label: '-5', labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xfff44336).withOpacity(0.7), win: false),
      SpinItem(label: '-7', labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xfff44336).withOpacity(0.7), win: false),
      SpinItem(label: '+15', labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xffffeb3b).withOpacity(0.7), win: true),
      SpinItem(label: '-3', labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xfff44336).withOpacity(0.7), win: false),
      SpinItem(label: '+2', labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xffffeb3b).withOpacity(0.7), win: true),
      SpinItem(label: '-1', labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xfff44336).withOpacity(0.7), win: false),
      SpinItem(label: '-1', labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xfff44336).withOpacity(0.7), win: false),
    ],
    [
      SpinItem(label: '+10', labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xffffeb3b).withOpacity(0.7), win: true),
      SpinItem(label: '-7', labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xfff44336).withOpacity(0.7), win: false),
      SpinItem(label: '-6', labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xfff44336).withOpacity(0.7), win: false),
      SpinItem(label: '+9', labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xffffeb3b).withOpacity(0.7), win: true),
      SpinItem(label: '-7', labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xfff44336).withOpacity(0.7), win: false),
      SpinItem(label: '+15', labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xffffeb3b).withOpacity(0.7), win: true),
      SpinItem(label: '-2', labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xfff44336).withOpacity(0.7), win: false),
      SpinItem(label: '+6', labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), color: const Color(0xffffeb3b).withOpacity(0.7), win: true),
    ],
  ];

  void _updateItemList() {
    /*if (spinCount < 5) {
      _currentItemList = spinStages[0]; // Low risk
    } else if (spinCount < 10) {
      _currentItemList = spinStages[1]; // Medium risk
    } else {
      _currentItemList = spinStages[2]; // High risk
    }*/
    //print(spinCount);
    setState(() {
      _currentItemList = spinStages[spinStage];
    });
  }

  void _onSpin() async {

    if(spinCount == 0) {
      await mySpinController.spinNow(luckyIndex: 4,totalSpin: 10,baseSpinDuration: 200);
      setState(() {
        coins+=1;//6
      });
      _generateCoins();
      spinStage++;
    } else if (spinCount == 1) {
      _updateItemList(); // Update rewards/losses based on spin count
      mySpinController.resetSpinner();
      coinsList.clear();
    } else if (spinCount == 2) {
      await mySpinController.spinNow(luckyIndex: 6,totalSpin: 10,baseSpinDuration: 200);
      setState(() {
        coins+=3;//9
      });
      _generateCoins();
      spinStage++;
    } else if (spinCount == 3) {
      _updateItemList(); // Update rewards/losses based on spin count
      mySpinController.resetSpinner();
      coinsList.clear();
    } else if (spinCount == 4) {
      await mySpinController.spinNow(luckyIndex: 2,totalSpin: 10,baseSpinDuration: 200);
      setState(() {
        coins-=1;//8
      });
      spinStage++;
    } else if (spinCount == 5) {
      _updateItemList(); // Update rewards/losses based on spin count
      mySpinController.resetSpinner();
      coinsList.clear();
    } else if (spinCount == 6) {
      await mySpinController.spinNow(luckyIndex: 2,totalSpin: 10,baseSpinDuration: 200);
      setState(() {
        coins-=4;//4
      });
      spinStage++;
    } else if (spinCount == 7) {
      _updateItemList(); // Update rewards/losses based on spin count
      mySpinController.resetSpinner();
      coinsList.clear();
    } else if (spinCount == 8) {
      await mySpinController.spinNow(luckyIndex: 6,totalSpin: 10,baseSpinDuration: 200);
      setState(() {
        coins+=2;//6
      });
      _generateCoins();
      spinStage++;
    } else if (spinCount == 9) {
      _updateItemList(); // Update rewards/losses based on spin count
      mySpinController.resetSpinner();
      coinsList.clear();
    } else if (spinCount == 10) {
      await mySpinController.spinNow(luckyIndex: 3,totalSpin: 10,baseSpinDuration: 200);
      setState(() {
        coins-=6;//0
      });
      spinStage++;
      if(mounted) {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent, // Transparent to show custom design
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.redAccent, width: 2), // Red border for loss
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(alignment: Alignment.centerLeft,child: IconButton(onPressed: () {
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        backgroundColor: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xffffeb3b), width: 2), // Green border for offer
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Align(alignment: Alignment.centerLeft,child: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close,color: Colors.redAccent,))),
                              const Text(
                                "Special Offer!",
                                style: TextStyle(
                                  color: Color(0xffffeb3b),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "+10%",
                                    style: TextStyle(color: Color(0xffffeb3b), fontSize: 24),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(width: 6,),
                                  Image(
                                    image: AssetImage(Assets.assetsCoins),
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                "You have a limited-time offer to get extra coins!",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // Additional action for claiming the offer
                                },
                                child: const Text(
                                  "Claim Offer",
                                  style: TextStyle(color: Color(0xffffeb3b), fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }, icon: const Icon(Icons.close,color: Colors.redAccent,))),
                  const Text(
                    "Oops!",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "You have lost all of your coins.",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Additional action for "Pay More"
                    },
                    child: const Text(
                      "Pay More",
                      style: TextStyle(color: Color(0xffffeb3b), fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent, // Transparent to show custom design
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.redAccent, width: 2), // Red border for loss
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(alignment: Alignment.centerLeft,child: IconButton(onPressed: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      backgroundColor: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xffffeb3b), width: 2), // Green border for offer
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(alignment: Alignment.centerLeft,child: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close,color: Colors.redAccent,))),
                            const Text(
                              "Special Offer!",
                              style: TextStyle(
                                color: Color(0xffffeb3b),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "+10%",
                                  style: TextStyle(color: Color(0xffffeb3b), fontSize: 24),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(width: 6,),
                                Image(
                                  image: AssetImage(Assets.assetsCoins),
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.contain,
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "You have a limited-time offer to get extra coins!",
                              style: TextStyle(color: Colors.white, fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                // Additional action for claiming the offer
                              },
                              child: const Text(
                                "Claim Offer",
                                style: TextStyle(color: Color(0xffffeb3b), fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }, icon: const Icon(Icons.close,color: Colors.redAccent,))),
                const Text(
                  "Oops!",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "You have lost all of your coins.",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Additional action for "Pay More"
                  },
                  child: const Text(
                    "Pay More",
                    style: TextStyle(color: Color(0xffffeb3b), fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    spinCount++;
  }

  @override
  Widget build(BuildContext context) {
    if(first) {
      first = false;
      _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))
        ..addListener(() {
          setState(() {});
        })
        ..repeat(); // Repeat the animation for a continuous drop effect
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3,tileMode: TileMode.decal),
            child: Image(
              image: const AssetImage(Assets.assetsOnlineCasinoCoinsBackground),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.75)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 54),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 30,),
                      const Image(
                        image: AssetImage(Assets.assetsAppIcon),
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                      ),
                      const Expanded(child: SizedBox()),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [
                                  Color(0xffffeb3b),
                                  Color(0xffffc107),
                                  Color(0xffff9800),
                                ]
                            ),
                            borderRadius: BorderRadius.circular(32)
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Color(0xfffff6b6),
                                        Color(0xffffe8b3),
                                        Color(0xffffdeac),
                                      ]
                                  ),
                                  shape: BoxShape.circle
                              ),
                              child: const Image(
                                image: AssetImage(Assets.assetsCoins),
                                width: 30,
                                height: 30,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 8,),
                            Text(
                              coins.toString(),
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.add_rounded,
                        color: Color(0xffffc107),
                        size: 50,
                      ),
                      const SizedBox(width: 0,),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.width*0.9,
                      width: MediaQuery.of(context).size.width*0.9,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          MySpinner(
                            mySpinController: mySpinController,
                            wheelSize: MediaQuery.of(context).size.width * 0.9,
                            itemList: _currentItemList,
                            onFinished: (p0) {

                            },
                            onSpinTap: _onSpin,
                            spinRound: spinCount % 2 == 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...coinsList.map((coin) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                double yPosition = (_controller.value * MediaQuery.of(context).size.height * coin.speed) % MediaQuery.of(context).size.height;
                return Positioned(
                  top: yPosition,
                  left: coin.x,
                  child: const IgnorePointer(
                    child: GradientIcon(
                      icon: Icons.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xffffeb3b),Color(0xffffc107),Color(0xffff9800), Color(0xffffeb3b),Color(0xffffc107),Color(0xffff9800), Color(0xffffeb3b),Color(0xffffc107),Color(0xffff9800)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      size: 30,
                    ),
                  ),
                );
              },
            );
          })
        ],
      ),
    );
  }
}

class SpinItem{
  String label;
  TextStyle labelStyle;
  Color color;
  bool win;

  SpinItem({
    required this.label,
    required this.color,
    required this.labelStyle,
    required this.win
  });
}

class MySpinner extends StatefulWidget {
  final MySpinController mySpinController;
  final List<SpinItem> itemList;
  final double wheelSize;
  final Function(SpinItem) onFinished;
  final Function() onSpinTap;
  final bool spinRound;
  const MySpinner({
    super.key,
    required this.mySpinController,
    required this.onFinished,
    required this.itemList,
    required this.wheelSize,
    required this.onSpinTap,
    required this.spinRound,
  });

  @override
  State<MySpinner> createState() => _MySpinnerState();
}

class _MySpinnerState extends State<MySpinner> with TickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
    widget.mySpinController.initLoad(
      tickerProvider: this,
      itemList: widget.itemList,
    );
  }

  @override
  void dispose() {
    super.dispose();
    null;
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          child: AnimatedBuilder(
            animation: widget.mySpinController._baseAnimation,
            builder: (context, child) {
              double value = widget.mySpinController._baseAnimation.value;
              double rotationValue = (360 * value);
              return RotationTransition(
                turns: AlwaysStoppedAnimation( rotationValue / 360 ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    RotatedBox(
                      quarterTurns: 3,
                      child: Container(
                          width: widget.wheelSize,
                          height: widget.wheelSize,
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xffffeb3b),Color(0xffffc107),Color(0xffff9800), Color(0xffffeb3b),Color(0xffffc107),Color(0xffff9800), Color(0xffffeb3b),Color(0xffffc107),Color(0xffff9800)], // Define the colors for the gradient
                                begin: Alignment.topLeft, // Define the starting point of the gradient
                                end: Alignment.bottomRight, // Define the ending point of the gradient
                                // You can also define more stops and their positions if needed
                                // stops: [0.2, 0.7],
                                // tileMode: TileMode.clamp,
                              ),
                              //color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Color(0xff795548),
                                shape: BoxShape.circle
                            ),

                            padding: const EdgeInsets.all(5),
                            child: CustomPaint(
                              painter: SpinWheelPainter(
                                  items: widget.itemList
                              ),
                            ),
                          )
                      ),
                    ),
                    ...widget.itemList.map((each) {
                      int index = widget.itemList.indexOf(each);
                      double rotateInterval = 360 / widget.itemList.length;
                      double rotateAmount = (index + 0.5) * rotateInterval;
                      return RotationTransition(
                        turns: AlwaysStoppedAnimation(rotateAmount/360),
                        child: Transform.translate(
                          offset: Offset(0,-widget.wheelSize/4),
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 12,),
                                Text(each.label,style: each.labelStyle),
                                const SizedBox(width: 8,),
                                if(each.win)Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            Color(0xfffff6b6),
                                            Color(0xffffe8b3),
                                            Color(0xffffdeac),
                                          ]
                                      ),
                                      shape: BoxShape.circle
                                  ),
                                  child: const Image(
                                    image: AssetImage(Assets.assetsCoins),
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    Container(
                      alignment: Alignment.center,
                      width: 25,
                      height: 25,
                      decoration: const BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        GestureDetector(
          onTap: widget.onSpinTap,
          child: Stack(
            children: [
              RotatedBox(
                quarterTurns: 3,
                child: Container(
                    height: MediaQuery.of(context).size.width*0.25,
                    width: MediaQuery.of(context).size.width*0.25,
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xffffeb3b),Color(0xffffc107),Color(0xffff9800), Color(0xffffeb3b),Color(0xffffc107),Color(0xffff9800), Color(0xffffeb3b),Color(0xffffc107),Color(0xffff9800)], // Define the colors for the gradient
                          begin: Alignment.topLeft, // Define the starting point of the gradient
                          end: Alignment.bottomRight, // Define the ending point of the gradient
                          // You can also define more stops and their positions if needed
                          // stops: [0.2, 0.7],
                          // tileMode: TileMode.clamp,
                        ),
                        //color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.width*0.25,
                      width: MediaQuery.of(context).size.width*0.25,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              colors: [
                                const Color(0xffffeb3b).withOpacity(0.8),
                                const Color(0xffffc107).withOpacity(0.8),
                                const Color(0xffff9800).withOpacity(0.8),
                              ]
                          ),
                          border: Border.all(
                              color: const Color(0xffff9800),
                              width: 5
                          )
                      ),
                      child: Text(
                        widget.spinRound?"SPIN":"UPDATE",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ),
              )
            ],
          ),
        ),
        Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 15, bottom: 5),
            padding: EdgeInsets.only(bottom: widget.wheelSize*0.30),
            child: Transform.rotate(
              angle: pi*1.5,
              child: const GradientIcon(
                icon: Icons.double_arrow_rounded,
                gradient: LinearGradient(
                  colors: [Color(0xffffeb3b),Color(0xffffc107),Color(0xffff9800), Color(0xffffeb3b),Color(0xffffc107),Color(0xffff9800), Color(0xffffeb3b),Color(0xffffc107),Color(0xffff9800)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                size: 60,
              ),
            )
        ),
      ],
    );
  }
}

class MySpinController{

  late AnimationController _baseAnimation;
  late TickerProvider _tickerProvider;
  bool _xSpinning = false;
  List<SpinItem> _itemList = [];

  Future<void> initLoad({
    required TickerProvider tickerProvider,
    required List<SpinItem> itemList,
  }) async{
    _tickerProvider = tickerProvider;
    _itemList = itemList;
    await setAnimations(_tickerProvider);
  }

  Future<void> setAnimations(TickerProvider tickerProvider) async{
    _baseAnimation = AnimationController(
      vsync: tickerProvider,
      duration: const Duration(milliseconds: 200),
    );
  }

  Future<void> spinNow({
    required int luckyIndex,
    int totalSpin = 10,
    int baseSpinDuration = 100
  }) async{

    //getWhereToStop
    int itemsLength = _itemList.length;
    int factor = luckyIndex % itemsLength;
    if(factor == 0) factor = itemsLength;
    double spinInterval = 1 / itemsLength;
    double target = 1 - ( (spinInterval * factor) - (spinInterval/2));

    if(!_xSpinning){
      _xSpinning = true;
      int spinCount = 0;

      do{
        _baseAnimation.reset();
        _baseAnimation.duration = Duration(milliseconds: baseSpinDuration);
        if(spinCount == totalSpin){
          await _baseAnimation.animateTo(target);
        }
        else{
          await _baseAnimation.forward();
        }
        baseSpinDuration = baseSpinDuration + 50;
        _baseAnimation.duration = Duration(milliseconds: baseSpinDuration);
        spinCount++;
      }
      while(spinCount <= totalSpin);

      _xSpinning = false;
    }
  }

  // New function to reset the spinner position to initial state
  Future<void> resetSpinner() async {
    if (!_xSpinning) {
      await _baseAnimation.animateBack(0.0, duration: const Duration(milliseconds: 500));
    }
  }

}

class SpinWheelPainter extends CustomPainter {
  final List<SpinItem> items;

  SpinWheelPainter({required this.items});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    final paint = Paint()
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.25) // Adjust the shadow color and opacity as needed
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10.0); // Adjust the blur radius as needed

    const spaceBetweenItems = 0.05; // Adjust this value to set the desired space between items
    final totalSections = items.length;
    const totalAngle = 2 * math.pi;
    final sectionAngleWithSpace = (totalAngle - (totalSections * spaceBetweenItems)) / totalSections;
    const spaceOnBothSides = spaceBetweenItems / 2;

    for (var i = 0; i < items.length; i++) {
      final startAngle = i * (sectionAngleWithSpace + spaceBetweenItems) + spaceOnBothSides;

      paint.color = items[i].color;

      // Draw shadow before drawing the arc
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sectionAngleWithSpace,
        true,
        shadowPaint,
      );

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sectionAngleWithSpace,
        true,
        paint,
      );
    }

    // Draw a circle at the center of the wheel
    final centerCircleRadius = radius * 0.05; // Adjust the radius of the center circle as needed
    final centerCirclePaint = Paint()..color = Colors.white; // Adjust the color of the center circle as needed
    canvas.drawCircle(center, centerCircleRadius, centerCirclePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class Coin {
  final double x; // x position
  final double speed; // falling speed

  Coin({required this.x, required this.speed});
}

