import 'package:flutter/material.dart';
import '../models/robot.dart';

class Nearby extends StatelessWidget {
  final List<Robot> robots = dummies;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Nearby Robots'),
        ),
        body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
          ),
          itemCount: robots.length,
          itemBuilder: (context, index) {
            return robots[index].getCard();
          },
        ),
      ),
    );
  }
}
