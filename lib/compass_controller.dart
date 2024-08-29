import 'dart:math' hide log;

import 'package:flutter/widgets.dart';
import 'dart:developer';

class CompassController extends ChangeNotifier {
  late ScrollController scrollController;
  double heading = 0;
  double targetHeading = 60;
  double itemWidth = 60;
  double width = 300;
  double scrollOffset = 0;
  int itemCount = 108;
  List<String> items = List<String>.generate(
      108, (index) => (10 * (index - 108 / 2)).toStringAsFixed(0));
  final showIndex = false;

  void initItems(double heading, double width, double itemWidth) {
    log("initItems: heading: $heading, width: $width, itemWidth: $itemWidth");
    if (heading < 0) heading += 360;
    this.heading = heading;
    this.width = width;
    this.itemWidth = itemWidth;
    items =
        List<String>.generate(itemCount, (index) => _getCompassLabel(index));

    scrollOffset = centerOffset;
    scrollController = ScrollController(initialScrollOffset: scrollOffset);
    Future.delayed(const Duration(seconds: 1), () {
      // scrollController.jumpTo(center);
    });
  }

  double get centerOffset => 36 * itemWidth - width / 2 + 5.5;

  void scrollToHeading(double heading) {
    if (heading < 0) heading += 360;

    double offset = getHeadingOffset(heading);
    int duration = max(offset.abs().ceil(), 100) * 5;

    //Spin back if out of range
    if (scrollOffset > itemCount * itemWidth - width) {
      scrollOffset -= 36 * itemWidth;
    } else if (scrollOffset < width / 2 + itemWidth) {
      scrollOffset += 36 * itemWidth;
    }
    offset += scrollOffset;
    scrollController.animateTo(offset,
        duration: Duration(milliseconds: duration), curve: Curves.decelerate);
    this.heading = heading;
    scrollOffset = offset;
    notifyListeners();
  }

  double getHeadingOffset(double currentHeading) {
    double offsetDegree = currentHeading - heading;
    if (offsetDegree > 180) {
      offsetDegree -= 360;
    } else if (offsetDegree < -180) {
      offsetDegree += 360;
    }
    return offsetDegree / 10 * itemWidth;
  }

  String _getCompassLabel(int index) {
    int degree = (index * 10) % 360;
    if (degree == 0) return 'N';
    if (degree == 90) return 'E';
    if (degree == 180) return 'S';
    if (degree == 270) return 'W';
    return '$degree';
  }
}
