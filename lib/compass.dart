import 'dart:ui';

import 'package:flutter/material.dart';

import 'compass_controller.dart';

class Compass extends StatelessWidget {
  final double width;
  final double itemWidth;
  final double initialHeading;
  final CompassController controller;

  Compass({
    super.key,
    this.width = 300,
    this.itemWidth = 60,
    required this.controller,
    this.initialHeading = 0,
  }) {
    controller.itemWidth = itemWidth;
    controller.initItems(initialHeading, width, itemWidth);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.only(top: 2, bottom: 2),
          width: width,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: Stack(
            children: [
              // Scrollable compass numbers
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: controller.scrollController,
                reverse: false,
                physics: const NeverScrollableScrollPhysics(),
                child: Row(children: [
                  for (int i = 0; i < controller.items.length; i++) itemBox(i)
                ]),
              ),
              Positioned(
                left: width / 2 - 20,
                top: -17,
                child: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double itemDegree(String item) {
    if (item == 'N') return 0;
    if (item == 'E') return 90;
    if (item == 'S') return 180;
    if (item == 'W') return 270;
    return double.parse(item);
  }

  Widget itemBox(int index) {
    String item = controller.items[index];
    Widget targetIcon = Container();
    double degree = itemDegree(item);
    if (degree == controller.targetHeading) {
      targetIcon = const Positioned(
        top: -2,
        left: -3,
        child: Icon(
          Icons.location_pin,
          color: Colors.green,
          size: 20,
        ),
      );
    }

    return SizedBox(
      width: itemWidth,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 1,
                    height: 8,
                    color: Colors.black,
                    padding: const EdgeInsets.only(bottom: 2),
                  ),
                  ListenableBuilder(
                      listenable: controller,
                      builder: (context, child) {
                        bool isCurrent = degree > controller.heading - 3 &&
                            degree < controller.heading + 3;
                        return Text(
                          item,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: isCurrent ? 16 : 12,
                            fontWeight: isCurrent ? FontWeight.bold : null,
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
          targetIcon,
          if (controller.showIndex)
            Positioned(
                bottom: 0,
                left: 20,
                child: Text(
                  "$index",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                )),
        ],
      ),
    );
  }
}
