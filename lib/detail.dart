import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class Detail extends StatefulWidget {
  final int index;
  const Detail({Key? key, required this.index}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {

  /// use to controller the rotation of the circle.
  /// an if else statement was added to the circle widget which determines the 
  /// rotation of circular widget based on if this varible is null or not
  /// the logic here is the value was made nullable.
  /// then assigned a value at initState(), since the Hero
  /// widget calculates the position of this widget before this class initState()
  /// the current value would be null at the point of calculation 
  /// hence the Hero widget animates to a position, then at initState the value changess
  /// which starts another animation as in the video
   double? rotationAngle;

  @override
  void initState() {
    super.initState();
    rotationAngle = -pi / 2;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    timeDilation = 4;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              child: Hero(
            tag: 'container${widget.index}',
            flightShuttleBuilder: (_, animation, flightDirection, __, ___) {
              return _flightShuttleBuilder(animation, flightDirection);
            },
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                // // ..translate(0.0 , 0.0,0.0)
                ..scale(2.0)
                ..rotateZ(pi * .5),
              // angle: pi/2,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                    height: size.width,
                    width: size.height,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(40))),
              ),
            ),
          )),
          Align(
            alignment: Alignment.topCenter,
            child: Hero(
              tag: 'circle${widget.index}',
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: rotationAngle),
                curve: Curves.linear,
                duration: const Duration(milliseconds: 1700),
                builder: (context, value, child) {
                  return Transform.rotate(
                    alignment: Alignment.center,
                    // transform: Matrix4.rotationZ(
                    angle:rotationAngle != null? (-value): 0,
                    // ..rotat((currentPage == index) ? value : 0)
                    // ..scale((currentPage == index) ? 1.1 : 1.0),
                    child: child!,
                    // angle: (currentPage == index) ? value : 0,
                  );
                },
                child: GestureDetector(
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //   return Detail(index: index);
                    // }));
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                        width: size.width / 2.7,
                        height: size.height / 2.7,
                        decoration: const BoxDecoration(
                            color: Colors.black, shape: BoxShape.circle),
                        child: Center(
                            child: Text(
                          widget.index.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 98),
                        ))),
                  ),
                ),
              ),
            ),
          ),
          Hero(
            tag: 'bottomContainer',
            flightShuttleBuilder: (_, animation, flightDirection, __, ___) {
              return _flightShuttleBuilderContainer(animation, flightDirection);
            },
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                  height: size.height / 1.7,
                  duration: const Duration(milliseconds: 50),
                  width: size.width,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40)),
                      color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }


  /// use to build the hero animation during transistion between pages.
  /// [Logic] ...isPop is used as a flag to know the current direction of the animation.
  /// the Hero parent widget to this widget passes it it's animation.
  /// the value variable then uses the animation value to create a new animation 
  /// the final trick was to set the values to be animated [scale and rotation property]
  /// of the tranform widge in this case to havve a final value equal to the 
  /// intended position of It's parent Hero widget when the value is 1 and a value equal
  /// to the origin position of this parent Hero widget when the value is 0.
  Widget _flightShuttleBuilder(
      Animation animation, HeroFlightDirection flightDirection) {
    final isPop = flightDirection == HeroFlightDirection.pop;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        Size size = MediaQuery.of(context).size;

        final value = isPop
            ? Curves.easeInBack.transform(animation.value)
            : Curves.ease.transform(animation.value);
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..scale(value + 1)
            // angle: pi/2 * value,
            // ..translate(0.0 , 0.0,0.0)
            ..rotateZ((pi * .5) * value),
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(40),
        ),
      ),
    );
  }

  Widget _flightShuttleBuilderCircle(
      Animation animation, HeroFlightDirection flightDirection, int index) {
    final isPop = flightDirection == HeroFlightDirection.pop;
    return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          Size size = MediaQuery.of(context).size;

          final value = isPop
              ? Curves.easeInBack.transform(animation.value)
              : Curves.ease.transform(animation.value);
          return Transform.rotate(
            alignment: Alignment.center,
            // transform: Matrix4.rotationZ(
            angle: (pi / 2) * value,
            // ..rotat((currentPage == index) ? value : 0)
            // ..scale((currentPage == index) ? 1.1 : 1.0),
            child: GestureDetector(
              onTap: () {
              },
              child: Material(
                color: Colors.transparent,
                child: Container(
                    width: size.width / 2.7,
                    height: size.height / 2.7,
                    decoration: const BoxDecoration(
                        color: Colors.black, shape: BoxShape.circle),
                    child: const Center(
                        child: Text(
                      'index.toString()',
                      style: TextStyle(color: Colors.white, fontSize: 8),
                    ))),
              ),
            ),
          );
        });
  }

  Widget _flightShuttleBuilderContainer(
      Animation animation, HeroFlightDirection flightDirection) {
    final isPop = flightDirection == HeroFlightDirection.pop;
    return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          Size size = MediaQuery.of(context).size;

          final value = isPop
              ? Curves.easeIn.transform(animation.value)
              : Curves.easeIn.transform(animation.value);
          return Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
                height: ((size.height / 1.7) * value),
                duration: const Duration(milliseconds: 15),
                width: size.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                    color: Colors.white)),
          );
        });
  }
}
