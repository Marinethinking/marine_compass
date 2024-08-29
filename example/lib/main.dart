import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:marine_compass/compass.dart';
import 'package:marine_compass/compass_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marine Compass Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CompassController controller = CompassController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Stack(
        children: [
          Center(
            child: Compass(
              controller: controller,
              width: 800,
              itemWidth: 50,
            ),
          ),
          Positioned(
              left: 10,
              bottom: 10,
              child: Joystick(listener: joystickListener)),
        ],
      ),
    );
  }

  joystickListener(StickDragDetails details) {
    if (details.x == 0) {
      return;
    }
    var heading = (atan2(details.y, details.x) * 180 / pi) + 90;
    controller.scrollToHeading(heading);
  }
}
