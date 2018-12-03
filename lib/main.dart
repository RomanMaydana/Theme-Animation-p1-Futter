import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  var darkThemeEnabled = false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
          stream: bloc.darkThemeEnabled,
          initialData: true,
          builder:(context,snapshot)=> MaterialApp(
          theme: snapshot.data ? ThemeData.dark() : ThemeData.light(),
          home: Scaffold(
            appBar: AppBar(
              title: Text('Theme option'),
            ),
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text('Dark Theme'),
                    trailing: Switch(
                      value: snapshot.data,
                      onChanged: bloc.changeTheme,
                    ),
                  )
                ],
              ),
            ),
            body: BodyPage(),
          )),
    );
  }
}

class Bloc {
  final _themeController = StreamController<bool>();
  get changeTheme => _themeController.sink.add;
  get darkThemeEnabled => _themeController.stream;
}
final bloc = Bloc();

class BodyPage extends StatefulWidget {
  @override
  _BodyPageState createState() => _BodyPageState();
}

class _BodyPageState extends State<BodyPage> with TickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animationController;
  Animation<Color> animationColor;
  AnimationController animationColorController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 5000));
    animation =
        Tween<double>(begin: 20.0, end: 300.0).animate(animationController);

    animation.addListener(() {
      print(animation.value.toString());
      setState(() {
        print(animation.value.toString());
      });
    });
    animation.addStatusListener((status) => print(status));
    animationController.forward();

    //animacion para Color
    animationColorController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 5000));
    animationColor = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(animationColorController);
    animationColorController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Center(
        child: Container(
          color: animationColor.value,
          height: animation.value,
          width: animation.value,
          child: FlutterLogo(),
        ),
      ),
      AnimatedLogo(
        animation: animation,
        widget: FlutterLogo(),
      )
    ]);
  }
}

class AnimatedLogo extends AnimatedWidget {
  final Tween<double> _sizeAnim = Tween<double>(begin: 50.0, end: 100.0);
  final Widget widget;
  AnimatedLogo({Key key, Animation animation, this.widget})
      : super(key: key, listenable: animation);
  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Transform.scale(
      scale: animation.value,
      child: widget,
    );
  }
}
//tween

//Physics Based
