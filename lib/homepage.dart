import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_delivery/detail.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  static const double menuHeight = 60;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _pageController = PageController(viewportFraction: 0.56);

  double page = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        page = _pageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Column(
            children: [
              const Expanded(child: SizedBox()),
              SizedBox(
                height: size.height * 0.42,
                child: PageView.builder(
                  padEnds: false,
                  clipBehavior: Clip.none,
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (_, i) {
                    return FoodCard(index: i, page: page);
                  },
                ),
              ),
              const SizedBox(height: MyHomePage.menuHeight + 30),
            ],
          ),
          const Hero(
            tag: 'menu_bar',
            child: MenuBar(menuHeight: MyHomePage.menuHeight),
          ),
        ],
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  const FoodCard({Key? key, required this.index, required this.page})
      : super(key: key);

  final int index;
  final double page;

  @override
  Widget build(BuildContext context) {
    ///This calculates the anim value from 0 to 1 based on the page's location
    ///and the item index so that it animates every frame.
    ///0 means it is at the current page and 1 means that it isn't
    ///Hint: 1 - val inverts the value so 1 means it is at the current page
    ///It interpolates from 0 to 1 lineraly
    var val = (index - page).abs().clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder<void>(
              transitionDuration: const Duration(milliseconds: 1500),
              reverseTransitionDuration: const Duration(milliseconds: 1500),
              pageBuilder: (_, anim, __) => Detail(
                index: index,
                transitionAnim: anim,
              ),
            ),
          );
        },
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            ///Card bg
            FoodBGWidget(index: index, val: val),
            LayoutBuilder(
              builder: (_, constraints) {
                var size = constraints.biggest;
                return Transform.translate(
                  offset: Offset(
                    0,
                    -size.height *
                        (0.46 - Curves.easeInCubic.transform(val) * 0.25),
                  ),
                  child: FoodWidget(
                    index: index,
                    animVal: val,
                    rotationVal: pi * 0.5 * val,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FoodBGWidget extends StatelessWidget {
  const FoodBGWidget({
    Key? key,
    required this.index,
    required this.val,
    this.transform,
  }) : super(key: key);

  final Matrix4? transform;
  final int index;
  final double val;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'food_bg_$index',
      flightShuttleBuilder: (_, anim, direction, __, ___) {
        return AnimatedBuilder(
          animation: anim,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..scale(anim.value + 1)
                ..rotateZ((pi * .5) * anim.value),
              child: child,
            );
          },
          child: _FoodBG(val: val),
        );
      },
      child: Transform(
        alignment: Alignment.center,
        transform: transform ?? Matrix4.identity(),
        child: _FoodBG(val: val),
      ),
    );
  }
}

class _FoodBG extends StatelessWidget {
  const _FoodBG({Key? key, required this.val}) : super(key: key);

  final double val;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16 * val),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(20 + 16 * (1 - val)),
      ),
    );
  }
}

class FoodWidget extends StatelessWidget {
  const FoodWidget({
    Key? key,
    required this.index,
    this.animVal = 0,
    this.rotationVal = 0,
  }) : super(key: key);

  final double animVal, rotationVal;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'food_widget_$index',
      child: LayoutBuilder(
        builder: (_, constraints) {
          return Material(
            type: MaterialType.transparency,
            child: Container(
              width: constraints.biggest.width * (0.8 - animVal * 0.1),
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 16,
                    spreadRadius: 6,
                    color: Colors.black38,
                    offset: Offset(0, 16),
                  ),
                ],
              ),
              child: Transform.rotate(
                angle: rotationVal,
                child: Container(
                  decoration: const BoxDecoration(color: Colors.black),
                  child: Center(
                    child: Text(
                      index.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 98),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MenuBar extends StatelessWidget {
  const MenuBar({Key? key, required this.menuHeight}) : super(key: key);

  final double menuHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: menuHeight,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 16, color: Colors.black26)],
        borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
      ),
    );
  }
}
