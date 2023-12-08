import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CoinTossPage(),
    );
  }
}

class CoinTossPage extends StatefulWidget {
  const CoinTossPage({super.key});

  @override
  State<CoinTossPage> createState() => _CoinTossPageState();
}

class _CoinTossPageState extends State<CoinTossPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationCtrl;
  late bool isHeads;
  final random = Random();
  late Animation<double> rotation;
  late Animation<double> verticalMovment;

  @override
  void dispose() {
    animationCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    animationCtrl = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    verticalMovment = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 0,
          end: -200,
        ),
        weight: 50,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: -200,
          end: 0,
        ),
        weight: 50,
      ),
    ]).animate(animationCtrl);

    rotation = Tween<double>(
      begin: 0,
      end: 2 * pi * 10,
    ).animate(animationCtrl);

    isHeads = random.nextBool();
  }

  void tossCoin() {
    double stopPosition = random.nextBool() ? 0.0 : 0.5;
    animationCtrl.value = stopPosition;
    animationCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedBuilder(
              animation: animationCtrl,
              builder: (BuildContext context, Widget? child) {
                double verticalOffset = verticalMovment.value;
                double value = rotation.value % (2 * pi);
                isHeads = random.nextBool();
                return Transform.translate(
                  offset: Offset(0, verticalOffset),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(value),
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(2, 3),
                            color: Color.fromARGB(255, 255, 255, 255),
                          )
                        ],
                        shape: BoxShape.circle,
                        color: isHeads ? Colors.redAccent : Colors.blueAccent,
                      ),
                      child: Center(
                        child: Text(
                          isHeads ? 'Tura' : 'Yazı',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: tossCoin,
              child: const Text('Havaya At'),
            )
          ],
        ),
      ),
    );
  }
}
