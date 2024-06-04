import 'dart:math';

import 'package:flutter/material.dart';

class BackgroundPage2 extends StatelessWidget {
  const BackgroundPage2({super.key});

  @override
  Widget build(BuildContext context) {
    const boxDecoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [.2, .8],
        colors: [
          Color(0xfff4af0c),
          Color(0xfffcedcc),
        ],
      ),
    );
    return Stack(
      children: [
        Container(
          decoration: boxDecoration,
        ),
        //Pink Box
        Positioned(
          bottom: -50,
          right: -40,
          child: _PinkBox(),
        ),
      ],
    );
  }
}

class _PinkBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -pi / 6,
      child: Container(
        width: 360,
        height: 360,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xff068a50),
            Color(0xff48933f),
          ]),
          borderRadius: BorderRadius.circular(80),
        ),
      ),
    );
  }
}
