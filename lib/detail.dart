import 'dart:math';
import 'package:flutter/material.dart';
import 'package:food_delivery/homepage.dart';

class Detail extends StatefulWidget {
  final int index;
  final Animation? transitionAnim;
  const Detail({Key? key, required this.index, this.transitionAnim})
      : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> with SingleTickerProviderStateMixin {
  late final AnimationController foodController;

  @override
  void initState() {
    super.initState();
    foodController = AnimationController(
      vsync: this,
      upperBound: pi * 2,
      duration: const Duration(seconds: 3),
    );
    if (widget.transitionAnim != null) {
      widget.transitionAnim!.addListener(() {
        if (widget.transitionAnim!.isCompleted) foodController.repeat();
      });
    } else {
      foodController.repeat();
    }
  }

  @override
  void dispose() {
    foodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        FoodBGWidget(
          val: 0,
          index: widget.index,
          transform: Matrix4.identity()
            ..scale(2.0)
            ..rotateZ(pi * .5),
        ),
        AnimatedBuilder(
          animation: foodController,
          builder: (_, child) => FoodWidget(
            index: widget.index,
            rotationVal: foodController.value,
          ),
        ),
        const Hero(
          tag: 'menu_bar',
          child: MenuBar(menuHeight: MyHomePage.menuHeight),
        ),
      ],
    );
  }
}
