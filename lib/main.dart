import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'widget.dart';
import 'timermodel.dart';
import 'setting.dart';
import 'timer.dart';
 import 'dart:async';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Work Timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: TimerHomePage(),
      
    );
  }
}
 
class TimerHomePage extends StatelessWidget {
  final double defaultPadding = 5.0;
  final CountDownTimer timer = CountDownTimer();
  
  @override
  Widget build(BuildContext context) {
    final List<PopupMenuItem<String>> menuItems = [];
     menuItems.add(PopupMenuItem(
      value: 'Settings',
      child: Text('Settings'),
    ));
   CountDownTimer timer = CountDownTimer();
      timer.startWork();


    return MaterialApp(
      title: 'My Work Timer',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text('My Work Timer'),
            actions: [
            PopupMenuButton<String>(
              itemBuilder: (BuildContext context) {
                return menuItems.toList();
              },
              onSelected: (s) { 
                if(s=='Settings') {
                  goToSettings(context);
                }
              },
          )
        ],
          ),
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
            final double availableWidth = constraints.maxWidth;
            return Column(children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                  Expanded(
                      child: ProductivityButton(
                          color: Colors.black,
                          text: "Work",
                          onPressed: () => timer.startWork())),
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                  Expanded(
                      child: ProductivityButton(
                          color: Colors.black,
                          text: "Short Break",
                          onPressed: () => timer.startBreak(true))),
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                  Expanded(
                      child: ProductivityButton(
                          color: Colors.black,
                          text: "Long Break",
                          onPressed:() => timer.startBreak(false))),
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                ],
              ),
              Expanded(
                  child: StreamBuilder(
                      initialData: TimerModel('00:00', 1),
                      stream: timer.stream(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        TimerModel timer = snapshot.data;
                        return Container(
                            child: CircularPercentIndicator(
                          radius: availableWidth / 2,
                          lineWidth: 10.0,
                          percent: (timer.percent == null) ? 1 : timer.percent,
                          center: Text( (timer.time == null) ? '00:00' : timer.time ,
                              style: Theme.of(context).textTheme.headline4),
                          progressColor: Colors.red,
                        ));
                      })),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                  Expanded(
                      child: ProductivityButton(
                          color: Color(0xff212121),
                          text: 'Stop',
                          onPressed: () => timer.stopTimer())),
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                  Expanded(
                      child: ProductivityButton(
                          color: Color.fromARGB(255, 56, 170, 45),
                          text: 'Restart',
                          onPressed: () => timer.startTimer())),
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                ],
              )
            ]);
          })),
    );
  }

  void emptyMethod() {}
  void goToSettings(BuildContext context) {
    print('in gotoSettings');
   Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsScreen()));
  }
}
