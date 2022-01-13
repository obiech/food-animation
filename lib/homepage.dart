import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_delivery/detail.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final _pageController = PageController(viewportFraction: 0.55);

  /// the currrent pageController.page rounded to positive inifinity
  int currentPage = 0;


  double rotation = 0;
  int currentIndex = 0;
  double position = 0;

  /// At initState _pageController.page might not yet have a value since
  /// it hasn't been built yet.
  /// it is worth noting that this value only deosn't exist when the app is lauched
  /// for the first time or during hot start.
  /// this variable is used to represent _pageController.page with a value of 
  /// 0 to prevent errors.
  /// the number 0 was used since the inital page of this pageController is set to 0
  double page = 0;

  double previousPage = 0;

  var isVisible = false;

  @override
  void initState() {
    page = (_pageController.positions.isNotEmpty) ? _pageController.page! : 0;

    _pageController.addListener(() {
      page = (_pageController.positions.isNotEmpty) ? _pageController.page! : 0;

      setState(() {
        currentPage = page.ceil();
        rotation = rotationAngle;
        position = positionTween;
        dev.log(rotation.toString());
      });
    });
    super.initState();
  }

// try using currentIndex -1
/// to get a custom scroll offset between page, this varible was added since I wanted the 
/// rotation of the circle to be in sync with the current scroll of each page
/// 
/// bug exists here
  double get rotationAngle {
    double b;
    if (previousPage < page) {
      b = (page - (page.floor()));
    } else {b = (page - (page.ceil() - 1));}
    previousPage = page;
    return b;
  }

 /// same with above
/// 
/// bug exists here

  double get positionTween {
    
    double a;
    if (previousPage < page) {
      a = (page - (page.floor()));
    } else {a = (page - (page.ceil() - 1));}
    previousPage = page;
    return a;
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
  
  /// the height of the circle
  double positionHeight(double value, int index, double height) {
    if ((page) == index) {
      return -(height / 15) - (height / 8);
    } else if (currentPage == index) {
      return -(height / 15) - ((height / 8) * value);
    } else {
      return -height / 15;
    }
  }

  /// the rotation of the circle

  double angle(double value, int index) {
    if ((page) == index) {
      return - (pi / 2);
    } else if (currentPage == index) {
      return -((pi / 2)* value);
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    timeDilation = 1;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height / 10),
          Padding(
            padding:
                EdgeInsets.only(left: size.width / 30, right: size.width / 30),
            child: TextFormField(
                decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(),
              fillColor: Colors.white,
              focusColor: Colors.white,
              hintText: 'Search for your favourite Food.',
              prefixIcon: Icon(Icons.search),
              disabledBorder: OutlineInputBorder(),
            )),
          ),
          SizedBox(height: size.height / 30),
          Padding(
              padding: EdgeInsets.only(
                left: size.width / 30,
              ),
              child: const Text(
                'Restaurants',
                style: TextStyle(color: Colors.grey, fontSize: 25),
              )),
          SizedBox(height: size.height / 80),
          SizedBox(
              child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: size.width / 30),
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              children: List.generate(10, (index) {
                return Container(
                    margin: EdgeInsets.only(right: size.width / 40),
                    width: size.width / 6,
                    height: size.height / 10,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(size.height / 50),
                        color: (index == 0) ? Colors.orange : Colors.white70),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Expanded(
                          flex: 6,
                          child: Icon(
                            Icons.food_bank,
                            size: 60,
                          ),
                        ),
                        (index == 0)
                            ? const Expanded(flex: 3, child: Text('data'))
                            : const Offstage()
                      ],
                    ));
              }),
            ),
          )),
          SizedBox(height: size.height / 40),
          Padding(
            padding: EdgeInsets.only(
              left: size.width / 30,
            ),
            child: RichText(
                text: TextSpan(
                    text: 'Most\n',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: size.height / 30),
                    children: [
                  TextSpan(
                    text: 'Popular Food',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: size.height / 30),
                  )
                ])),
          ),
          SizedBox(height: size.height / 7),
          Flexible(
            // flex: 6,
            child: Transform.translate(
              offset: Offset(-size.width / 5.5, 0),
              child: PageView.builder(
                clipBehavior: Clip.none,
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  currentIndex = index;
                  return Stack(clipBehavior: Clip.none, children: [
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width / 30),
                        child: Hero(
                            tag: 'container${index}',
                            child: Transform.rotate(
                                alignment: Alignment.center,
                                angle: 0,
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          PageRouteBuilder<void>(pageBuilder:
                                              (BuildContext context,
                                                  Animation<double> animation,
                                                  Animation<double>
                                                      secondaryAnimation) {
                                        return AnimatedBuilder(
                                            animation: animation,
                                            builder: (BuildContext context,
                                                Widget? child) {
                                              return Detail(index: index);
                                            });
                                      }));
                                    },
                                    child: SizedBox.expand(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: size.width / 20),
                                        decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              for (int i = 0;
                                                  i < list.length;
                                                  i++)
                                                list[i],
                                              AnimatedContainer(
                                                curve: Curves.easeIn,
                                                height: currentPage == index
                                                    ? 70
                                                    : 0,
                                                duration: const Duration(
                                                    milliseconds: 100),
                                                child: const Text(
                                                  'on the other hand, we deliever,\n with tp notice servces ',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              const Text(
                                                '\$12.06',
                                                style: TextStyle(
                                                    fontSize: 40,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              // currentPage == index?
                                              TweenAnimationBuilder<Color?>(
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  tween:
                                                      ColorTween(begin: null, end:currentPage == index?Colors.white:Colors.transparent),
                                                  builder:
                                                      (context, value, child) {
                                                    return AnimatedContainer(
                                                        duration: const Duration(
                                                            milliseconds: 10),
                                                        width: size.width / 4,
                                                        height:currentPage == index? (size.height /
                                                                    20): 10,
                                                        margin: EdgeInsets.only(
                                                            left:
                                                                size.width / 6,
                                                            top: size.height /
                                                                50,
                                                            bottom:
                                                                size.height /
                                                                    60),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          color: value,
                                                        ));
                                                  })
                                            ]),
                                      ),
                                    ))))),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: position),
                      curve: Curves.easeIn,
                      duration: const Duration(milliseconds: 2),
                      builder: (context, value, child) {
                        final b = Curves.ease.transform(position);
                        return Align(
                          alignment: Alignment.topCenter,
                          child: Stack(clipBehavior: Clip.none, children: [
                            AnimatedPositioned(
                              left: 40,
                              top: positionHeight(value, index, size.height),
                              child: child!,
                              duration: const Duration(milliseconds: 100),
                            ),
                          ]),
                        );
                      },
                      child: Hero(
                        flightShuttleBuilder:
                            (_, animation, flightDirection, __, ___) {
                          return _flightShuttleBuilderCircle(
                              animation, flightDirection, index);
                        },
                        tag: 'circle${index}',
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: rotation),
                          curve: Curves.decelerate,
                          duration: const Duration(milliseconds: 100),
                          builder: (context, value, child) {
                            return Transform.rotate(
                              alignment: Alignment.center,
                              // transform: Matrix4.rotationZ(
                              // ? (pi / 2)
                              // ..rotateZ((currentPage == index)
                              angle: angle(value, index, ),
                              // angle:  (currentPage == index) ? (pi /2 )*value: 0.0,
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
                                      color: Colors.black,
                                      shape: BoxShape.circle),
                                  child: Center(
                                      child: Text(
                                    index.toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 98),
                                  ))),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]);
                },
              ),
            ),
          ),
          SizedBox(
            height: size.height / 30,
          ),
          Hero(
            tag: 'bottomContainer',
            // flightShuttleBuilder: (_, animation, flightDirection, __, ___) {
            //     return _flightShuttleBuilderContainer(animation, flightDirection);
            //   },
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                  height: 0,
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

  Widget _flightShuttleBuilderCircle(
      Animation animation, HeroFlightDirection flightDirection, int index) {
    final isPop = flightDirection == HeroFlightDirection.pop;
    return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          Size size = MediaQuery.of(context).size;

          final value = isPop
              ? Curves.easeInBack.transform(animation.value)
              : Curves.easeIn.transform((animation.value as double) + 0.2);
          dev.log(value.toString(), name: 'circle');
    
          // if (value ==0) {anglee = -pi / 2;}
          return Transform.rotate(
            alignment: Alignment.center,
            // transform: Matrix4.rotationZ(
            angle: -(pi /2) + ((pi/2 )*(value )),
            // ..rotat((currentPage == index) ? value : 0)
            // ..scale((currentPage == index) ? 1.1 : 1.0),
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
                      index.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 98),
                    ))),
              ),
            ),
          );
        });
  }
}

List<Widget> list = [
  RichText(
      text: TextSpan(
          text: '.',
          style: TextStyle(
              fontSize: 80, fontWeight: FontWeight.bold, color: Colors.black),
          children: [
        TextSpan(
          text: '.',
          style: TextStyle(
              fontSize: 80, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        TextSpan(
          text: '.',
          style: TextStyle(
              fontSize: 80, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        TextSpan(
          text: '.',
          style: TextStyle(
              fontSize: 80, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        TextSpan(
          text: '.',
          style: TextStyle(
              fontSize: 80, fontWeight: FontWeight.bold, color: Colors.white70),
        ),
      ])),
  Text(
    'Fusilli Pasta \nShrimp',
    style: TextStyle(
        fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
  )
];
