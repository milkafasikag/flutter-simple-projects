import 'dart:math';
import 'package:flutter/material.dart';
import 'ball.dart';
import 'bat.dart';
import 'package:flutter/material.dart';

enum Direction { up, down, left, right }

class Pong extends StatefulWidget {
  @override
  _PongState createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin {

  double? width;
  double? height;
  double? posX;
  double? posY;
  double ?batWidth;
  double? batHeight;
  double batPosition = 0;
  Direction vDir = Direction.down;
  Direction hDir = Direction.right;
  Animation<double> ?animation;
  AnimationController? controller;
  double increment = 5;
  double randX = 1;
  double randY = 1;
  int score = 0;
  @override
  void initState() {
    super.initState();
    posX = 0;
    posY = 0;
    controller = AnimationController(
      duration: const Duration(minutes: 10000),
      vsync: this,
    );

    animation = Tween<double>(begin: 0, end: 100).animate(controller!);
    animation?.addListener(() {
  setState(() {
  checkBorders();
  if (hDir == Direction.right) {
    posX = posX! + (increment * (randX ?? 0));
  } else {
    posX = posX! - (increment * (randX ?? 0));
  }
  if (vDir == Direction.down) {
    posY = posY! + (increment * (randY ?? 0));
  } else {
    posY = posY! - (increment * (randY ?? 0));
  }
});
checkBorders();
        });
     

    controller?.forward();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
       builder: (BuildContext context, BoxConstraints constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        batWidth = width! / 5;
        batHeight = height! / 20;

         return Stack(
           children: <Widget>[
                         Positioned(
              top: 0,
              right: 24,
              child: Text('Score: ' + score.toString()),
            ),

             Positioned(
               child: Ball(),
               top: posY,
               left: posX,
              ),
              Positioned(
                bottom: 0,
                left: batPosition,
                child:  GestureDetector(
                    onHorizontalDragUpdate: (DragUpdateDetails update) =>
                        moveBat(update, context),
                    child: Bat(batWidth!, batHeight!))),
           ],
         );
       }
    );
  }

  void checkBorders() {
    double diameter = 50;
    if (posX! <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
      randX = randomNumber();
    }
    if (posX! >= width! - diameter && hDir == Direction.right) {
      hDir = Direction.left;
      randX = randomNumber();
    }
    //check the bat position as well
     if (posY! >= height! - diameter - batHeight!  && vDir == Direction.down) {
      //check if the bat is here, otherwise loose
      if (posX! >= (batPosition - diameter) && posX! <= (batPosition + batWidth! + diameter)) {
        vDir = Direction.up;
        randY = randomNumber();
        setState(() {
         score++; 
        });

      } else {
        controller?.stop();
        showMessage(context);       
      }
    }
    if (posY! <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
      randX = randomNumber();
    }
  }

  void moveBat(DragUpdateDetails update, BuildContext context) {
    setState(() {
      batPosition += update.delta.dx;
    });
  }

  double randomNumber() {
    
    var ran = new Random();
    int myNum = ran.nextInt(100);
    return (50 + myNum) / 100;
  }

  void showMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('Would you like to play again?'),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                setState(() {
                  posX = 0;
                  posY = 0;
                  score = 0; 
                });
                Navigator.of(context).pop();
                controller?.repeat();
              },
            ),
            TextButton (
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
                dispose();
              },)
          ],
        );
      }
    );
  }

}